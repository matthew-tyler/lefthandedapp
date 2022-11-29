/*
	MyCanvas.swift
*/
import Foundation
import SwiftUI
import PencilKit

struct MyCanvas: UIViewRepresentable
	{
	@Binding var canvasView: PredictiveCanvasview

	func makeUIView(context: Context) -> PKCanvasView
		{
		canvasView.drawingPolicy = .anyInput
		canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
            
    

		return canvasView
		}

	func updateUIView(_ canvasView: PKCanvasView, context: Context)
		{
		/* Nothing */
		}
	}






class Stroke {
    var samples = [StrokeSample]()
    var predictedSamples = [StrokeSample]()
    
    
    func add(sample: StrokeSample) {
        samples.append(sample)
    }
    
    func addPredicted(sample: StrokeSample) {
          predictedSamples.append(sample)
      }
}
 
struct StrokeSample {
    // Always.
    let timestamp: TimeInterval
    let location: CGPoint
    
    // 3D Touch or Pencil.
    var force: CGFloat?
    
    // Pencil only.
    var estimatedProperties: UITouch.Properties = []
    var estimatedPropertiesExpectingUpdates: UITouch.Properties = []
    var altitude: CGFloat?
    var azimuth: CGFloat?
    
    init(timestamp: TimeInterval,
         location: CGPoint,
         coalesced: Bool,
         predicted: Bool = false,
         force: CGFloat? = nil,
         azimuth: CGFloat? = nil,
         altitude: CGFloat? = nil,
         estimatedProperties: UITouch.Properties = [],
         estimatedPropertiesExpectingUpdates: UITouch.Properties = []) {

        self.timestamp = timestamp
        self.location = location
        self.force = force
        self.coalesced = coalesced
        self.predicted = predicted
        self.altitude = altitude
        self.azimuth = azimuth
    }

    /// Convenience accessor returns a non-optional (Default: 1.0)
    var forceWithDefault: CGFloat {
        return force ?? 1.0
    }

    /// Returns the force perpendicular to the screen. The regular pencil force is along the pencil axis.
    var perpendicularForce: CGFloat {
        let force = forceWithDefault
        if let altitude = altitude {
            let result = force / CGFloat(sin(Double(altitude)))
            return result
        } else {
            return force
        }
    }
    
    // Values for debug display.
    let coalesced: Bool
    let predicted: Bool
}

class StrokeCollection {
    var strokes = [Stroke]()
    var activeStroke: Stroke? = nil
 
    func acceptActiveStroke() {
        if let stroke = activeStroke {
            strokes.append(stroke)
            activeStroke = nil
        }
    }
}


class PredictiveCanvasview: PKCanvasView{
    
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
        if let coalesced = event?.coalescedTouches(for: touches.first!) {
            addSamples(for: coalesced)
        }
        
        if let predicted = event?.predictedTouches(for: touches.first!){
            addSamples(for: predicted, predicted: true)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let coalesced = event?.coalescedTouches(for: touches.first!) {
            addSamples(for: coalesced)
            
        }
        
        if let predicted = event?.predictedTouches(for: touches.first!){
            addSamples(for: predicted, predicted: true)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Accept the current stroke and add it to the stroke collection.
        if let coalesced = event?.coalescedTouches(for: touches.first!) {
            addSamples(for: coalesced)
        }
        
        if let predicted = event?.predictedTouches(for: touches.first!){
            addSamples(for: predicted, predicted: true)
        }
        // Accept the active stroke.
        strokeCollection?.acceptActiveStroke()
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Clear the last stroke.
        strokeCollection?.activeStroke = nil
    }
    
    func addSamples(for touches: [UITouch], predicted: Bool = false) {
        
       
        if let stroke = strokeCollection?.activeStroke {
            
            // Add all of the touches to the active stroke.
            for touch in touches {
    
                if (predicted){
                    let sample = StrokeSample(timestamp: touch.timestamp, location: touch.preciseLocation(in: self), coalesced: false,predicted: true ,force: touch.force,azimuth: touch.azimuthAngle(in: self),altitude: touch.altitudeAngle,estimatedProperties: touch.estimatedProperties,estimatedPropertiesExpectingUpdates: touch.estimatedPropertiesExpectingUpdates)
                    stroke.addPredicted(sample: sample)
                    continue
                }

                if touch == touches.last {
                    
                    let sample = StrokeSample(timestamp: touch.timestamp, location: touch.preciseLocation(in: self), coalesced: false, force: touch.force,azimuth: touch.azimuthAngle(in: self),altitude: touch.altitudeAngle,estimatedProperties: touch.estimatedProperties,estimatedPropertiesExpectingUpdates: touch.estimatedPropertiesExpectingUpdates)
                    stroke.add(sample: sample)
                    
                } else {
                    // If the touch is not the last one in the array,
                    //  it was a coalesced touch.
                    let sample = StrokeSample(timestamp: touch.timestamp, location: touch.preciseLocation(in: self), coalesced: true, force: touch.force,azimuth: touch.azimuthAngle(in: self),altitude: touch.altitudeAngle,estimatedProperties: touch.estimatedProperties,estimatedPropertiesExpectingUpdates: touch.estimatedPropertiesExpectingUpdates)
                    stroke.add(sample: sample)
                }
            }
            // Update the view.
            self.setNeedsDisplay()
        }
    }
}


//init(timestamp: TimeInterval,
//     location: CGPoint,
//     coalesced: Bool,
//     predicted: Bool = false,
//     force: CGFloat? = nil,
//     azimuth: CGFloat? = nil,
//     altitude: CGFloat? = nil,
//     estimatedProperties: UITouch.Properties = [],
//     estimatedPropertiesExpectingUpdates: UITouch.Properties = [])
