/*
 MyCanvas.swift
 */
import Foundation
import PencilKit
import SwiftUI

struct MyCanvas: UIViewRepresentable {
    @Binding var canvasView: HighFidlityCanvas

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .pencilOnly
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 2)
        canvasView.strokeCollection = PKDrawing()

    
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        /* Nothing */
    }
}

class HighFidlityCanvas: PKCanvasView {
    var strokeCollection: PKDrawing?
    
    var activeStroke: [PKStrokePoint]?
    var firstStrokeTimeStamp: TimeInterval?
    var creationDate: Date?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeStroke = []
        
        let pencilTouch = touches.first(where: {$0.type == UITouch.TouchType.pencil} )
        
        guard let pencilTouch else{
            super.touchesBegan(touches, with: event)
            return
        }
               
        if let coalesced = event?.coalescedTouches(for: pencilTouch) {
            firstStrokeTimeStamp = pencilTouch.timestamp
            creationDate = Date()
             
            for touch in coalesced {
                addSample(touch)
            }
        }
         
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let pencilTouch = touches.first(where: {$0.type == UITouch.TouchType.pencil})
        
        guard let pencilTouch else{
            super.touchesMoved(touches, with: event)
            return
        }
        
        if let coalesced = event?.coalescedTouches(for: pencilTouch) {
            for touch in coalesced {
                addSample(touch)
            }
        }
        
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let pencilTouch = touches.first(where: {$0.type == UITouch.TouchType.pencil} )
        
        guard let pencilTouch else{
            super.touchesEnded(touches, with: event)
            return
        }
                
        if let coalesced = event?.coalescedTouches(for: pencilTouch) {
            for touch in coalesced {
                addSample(touch)
            }
        }
        
        let path = PKStrokePath(controlPoints: activeStroke!, creationDate: creationDate!)
        let stroke = PKStroke(ink: PKInk(PKInk.InkType.pen), path: path)
        
        strokeCollection?.strokes.append(stroke)
        
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let pencilTouch = touches.first(where: {$0.type == UITouch.TouchType.pencil} )
        
        guard pencilTouch != nil else{
            super.touchesCancelled(touches, with: event)
            return
        }
        // Clear the last stroke.
        activeStroke = nil
        firstStrokeTimeStamp = nil
        creationDate = nil
        super.touchesCancelled(touches, with: event)
    }
    
    func addSample(_ touch: UITouch) {
        
        guard let firstStrokeTimeStamp else {return}
        
        let sample = PKStrokePoint(location: touch.preciseLocation(in: self), timeOffset: touch.timestamp - firstStrokeTimeStamp,
                                   size: CGSize(width: 2, height: 2), opacity: CGFloat(1),
                                   force: touch.force, azimuth: touch.azimuthAngle(in: self), altitude: touch.altitudeAngle)
        
        activeStroke?.append(sample)
    }
}
 
