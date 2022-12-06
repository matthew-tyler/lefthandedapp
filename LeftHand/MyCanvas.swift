/*
 MyCanvas.swift
 */
import Foundation
import PencilKit
import SwiftUI

struct MyCanvas: UIViewRepresentable {
    @Binding var canvasView: PredictiveCanvasview

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        canvasView.strokeCollection = StrokeCollection()
    
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        /* Nothing */
    }
}


 
struct PenSample {
    // Always.
    let timestamp: TimeInterval
    let totalElapsedTime: TimeInterval
    let location: CGPoint
    
    // 3D Touch or Pencil.
    var force: CGFloat
    
    // Pencil only.
    var estimatedProperties: UITouch.Properties = []
    var estimatedPropertiesExpectingUpdates: UITouch.Properties = []
    var altitude: CGFloat
    var azimuth: CGFloat
    
    init(timestamp: TimeInterval,
         totalElapsedTime: TimeInterval,
         location: CGPoint,
         coalesced: Bool,
         predicted: Bool = false,
         force: CGFloat,
         azimuth: CGFloat,
         altitude: CGFloat,
         estimatedProperties: UITouch.Properties = [],
         estimatedPropertiesExpectingUpdates: UITouch.Properties = [])
    {
        self.timestamp = timestamp
        self.totalElapsedTime = totalElapsedTime
        self.location = location
        self.force = force
        self.coalesced = coalesced
        self.predicted = predicted
        self.altitude = altitude
        self.azimuth = azimuth
    }

    /// Returns the force perpendicular to the screen. The regular pencil force is along the pencil axis.
    var perpendicularForce: CGFloat {
        let result = force / CGFloat(sin(Double(altitude)))
        return result
    }
    
    // Values for debug display.
    let coalesced: Bool
    let predicted: Bool
    
    func asData() -> Data {
        let utfDescription = "PenSample," + timestamp.description + ","
            + location.x.description + "," + location.y.description + ","
            + force.description + "," + altitude.description + ","
            + azimuth.description + "," + predicted.description + "\n"

        return utfDescription.data(using: .utf8)!
    }
}

struct StrokeSample {
    
    let sample: PenSample
    var predictedSamples: [PenSample] = []
    
    func asData() -> Data {

        var utf8StrokeSample = sample.asData()

        for predictedSample in predictedSamples {
            
            utf8StrokeSample.append(predictedSample.asData())
        }

        return utf8StrokeSample
    }
    
}


public class Stroke {
    
    var samples = [StrokeSample]()
    

    func add(sample: StrokeSample) {
        samples.append(sample)
    }
    

    func asData() -> Data{

        var strokeUTF8 = "Stroke\n".data(using: .utf8)

        for sample in samples {
            
            strokeUTF8?.append(sample.asData())
        }

        return strokeUTF8!
    }
}

class StrokeCollection {
    
    var strokes = [Stroke]()
    var activeStroke: Stroke?
    var activeStrokeInitalTimeStamp: TimeInterval?
 
    func acceptActiveStroke() {
        if let stroke = activeStroke {
            strokes.append(stroke)
            activeStroke = nil
        }
    }
    
    func asData() -> Data {

        var utf8StrokeCollection = Data()

        for stroke in strokes {

            utf8StrokeCollection.append(stroke.asData())
        }


        return utf8StrokeCollection
    }
}

class PredictiveCanvasview: PKCanvasView {
    var strokeCollection: StrokeCollection? {
        didSet {
            // If the strokes change, redraw the view's content.
            if oldValue !== strokeCollection {
                setNeedsDisplay()
            }
        }
    }
    
    
    // Touch Handling methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Create a new stroke and make it the active stroke.
        let newStroke = Stroke()
        strokeCollection?.activeStroke = newStroke
        
        // The view does not support multitouch, so get the samples
        //  for only the first touch in the event.
        
        
        let predictedTouches = event?.predictedTouches(for: touches.first!)
        
        
        
        if let coalesced = event?.coalescedTouches(for: touches.first!) {

            strokeCollection?.activeStrokeInitalTimeStamp = touches.first!.timestamp
           
            for touch in coalesced {
                

                
                addSamples(for: touch, and: predictedTouches)
                        
            }
           
        }
        

    }
    

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
                
        let predictedTouches = event?.predictedTouches(for: touches.first!)
        
        
//        print(Unmanaged<AnyObject>.passUnretained(touches.first! as AnyObject).toOpaque(),touches.first!)
//        print(Unmanaged<AnyObject>.passUnretained(test as AnyObject).toOpaque(),test)
        
        
        
            
 
        if let coalesced = event?.coalescedTouches(for: touches.first!) {
            
       
            for touch in coalesced {

                addSamples(for: touch, and: predictedTouches)
                
                        
            }
            
          
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let predictedTouches = event?.predictedTouches(for: touches.first!)
        
        if let coalesced = event?.coalescedTouches(for: touches.first!) {
            
            for touch in coalesced {
                
                addSamples(for: touch, and: predictedTouches)
                        
            }
           
            strokeCollection?.acceptActiveStroke()
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Clear the last stroke.
        strokeCollection?.activeStroke = nil
    }
    
    
    
    func addSamples(for touch: UITouch, and predictedTouches: [UITouch]? = nil ) {
        
        
        if let stroke = strokeCollection?.activeStroke {
            
            let initialTimeStamp = strokeCollection?.activeStrokeInitalTimeStamp
            
            
            let sample = PenSample(timestamp: touch.timestamp - initialTimeStamp!, totalElapsedTime: touch.timestamp, location: touch.preciseLocation(in: self), coalesced: false, force: touch.force, azimuth: touch.azimuthAngle(in: self), altitude: touch.altitudeAngle, estimatedProperties: touch.estimatedProperties, estimatedPropertiesExpectingUpdates: touch.estimatedPropertiesExpectingUpdates)
             
            var currentStrokeSample = StrokeSample(sample: sample)
            
            
            // Add all of the touches to the active stroke.
            if let predictedTouches {
            
                for predictedTouch in predictedTouches{
                    
                    let pSample = PenSample(timestamp: predictedTouch.timestamp - initialTimeStamp!, totalElapsedTime: predictedTouch.timestamp, location: predictedTouch.preciseLocation(in: self), coalesced: false, predicted: true, force: predictedTouch.force, azimuth: predictedTouch.azimuthAngle(in: self), altitude: predictedTouch.altitudeAngle, estimatedProperties: predictedTouch.estimatedProperties, estimatedPropertiesExpectingUpdates: predictedTouch.estimatedPropertiesExpectingUpdates)
                    
                        currentStrokeSample.predictedSamples.append(pSample)
                }
                 
            }
            
            stroke.add(sample: currentStrokeSample)
            
       
        }
    }
}


public class TouchEvent: UITouch {
    
    
    override public var force: CGFloat { get { return _force } }
    public var _force: CGFloat
    
    override public var timestamp: TimeInterval { get { return _timestamp } }
    public var _timestamp: TimeInterval
    
    override public var altitudeAngle: CGFloat { get { return _altitudeAngle } }
    public var _altitudeAngle: CGFloat
    
    override public var window: UIWindow? { get { return _window } }
    public var _window: UIWindow?
    
     init(force: CGFloat, timestamp: TimeInterval, altitudeAngle: CGFloat, window: UIWindow){
        self._force = force
        self._timestamp = timestamp
        self._altitudeAngle = altitudeAngle
        self._window = window
    }
    
    
}
