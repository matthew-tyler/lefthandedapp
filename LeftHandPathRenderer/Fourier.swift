//
//  Fourier.swift
//  LeftHandPathRenderer
//
//  Created by Matt Tyler on 21/11/22.
//

import Foundation
import PencilKit

import Accelerate

class Fourier {
    
    
    
    var log2n : vDSP_Length? = nil
    var fftSetUp : vDSP.FFT<DSPSplitComplex>?
    

    struct v_point: Identifiable {
        var id = UUID()
        var distance: Float
        var time: Float
    }
    
    func transform(_ vector: [v_point]) -> [Float] {
        
        
        var padded = padSignal(vector)
        
        
        var signal = padded.map{$0.distance}
        
        let frameCount = signal.count
        

        let reals = UnsafeMutableBufferPointer<Float>.allocate(capacity: frameCount)
        defer {reals.deallocate()}
        let imags =  UnsafeMutableBufferPointer<Float>.allocate(capacity: frameCount)
        defer {imags.deallocate()}
        _ = reals.initialize(from: signal)
        imags.initialize(repeating: 0.0)
        
        var complexBuffer = DSPSplitComplex(realp: reals.baseAddress!, imagp: imags.baseAddress!)

        let log2Size = Int(log2(Float(frameCount)))


        guard let fftSetup = vDSP_create_fftsetup(vDSP_Length(log2Size), FFTRadix(kFFTRadix2)) else {
            return []
        }
        
        defer {vDSP_destroy_fftsetup(fftSetup)}

        // Perform a forward FFT
        vDSP_fft_zip(fftSetup, &complexBuffer, 1, vDSP_Length(log2Size), FFTDirection(FFT_FORWARD))

        
        var shortReal = Array<Float>(repeating: 0, count: 200)
        _ = shortReal.withContiguousMutableStorageIfAvailable {
            UnsafeMutableRawPointer($0.baseAddress!).copyMemory(from: complexBuffer.realp, byteCount: MemoryLayout<Float>.size * 200)
        }
    
        
        var shortImag = Array<Float>(repeating: 0, count: 200)
        _ = shortImag.withContiguousMutableStorageIfAvailable {
            UnsafeMutableRawPointer($0.baseAddress!).copyMemory(from: complexBuffer.imagp, byteCount: MemoryLayout<Float>.size * 200)
           
        }
        
        
  
        
        
        let shortReals = UnsafeMutableBufferPointer<Float>.allocate(capacity: 200)
        defer { shortReals.deallocate() }
        
        let shortImags = UnsafeMutableBufferPointer<Float>.allocate(capacity: 200)
        defer { shortImags.deallocate() }
        
        _ = shortReals.initialize(from: shortReal)
        shortImags.initialize(from: shortImag)
        
        var shortBuffer = DSPSplitComplex(realp: shortReals.baseAddress!, imagp: shortImags.baseAddress!)
        
        

        let output = UnsafeMutablePointer<Float>.allocate(capacity: 200)


        vDSP_zvmags(
              &shortBuffer,
            1,
             output,
             1,
              vDSP_Length((200 / 2))
        )
        
        var mags = Array<Float>(repeating: 0, count: frameCount)
        _ = mags.withContiguousMutableStorageIfAvailable {
          UnsafeMutableRawPointer($0.baseAddress!).copyMemory(from: output, byteCount: MemoryLayout<Float>.size * frameCount)
        }

        var realFloats = Array(reals)
        var imaginaryFloats = Array(imags)
        
        print(realFloats)
        print(shortReal)
        
        
//
//        print(mags)


        return mags
    }
    
    
    
    
    func padSignal(_ vector: [v_point]) -> [v_point] {
        
        var padded = vector;
        
        while (padded.count % 2 != 0){
            
            padded.append(v_point(distance: 0.0, time: 0.0))
        }
        
        return padded
    }
    
    func vectorise(_ path: PKDrawing) -> [v_point] {
        var vector: [v_point] = []
        
    
        
        var distOffset = 0.0
        
        var timeOffset = 0.0
        
        for stroke in path.strokes {
            var prev_point: PKStrokePoint?
            var distAccumulator = 0.0
            var timeAccumulator = 0.0
            
            for point in stroke.path {
                if prev_point == nil {
                    prev_point = point
                    continue
                }
                
                let xes = (prev_point!.location.x - point.location.x)

                let yes = (prev_point!.location.y - point.location.y)
                
                let summed = pow(xes, 2) + pow(yes, 2)
                
                let dist = sqrt(summed)

                distAccumulator += dist
                timeAccumulator = point.timeOffset
                
                let vpDistance = distAccumulator + distOffset
                
                let vpTime = (point.timeOffset + timeOffset)
                
                let vectorPoint = v_point(distance: Float(vpDistance), time: Float(vpTime))
                
                vector.append(vectorPoint)
            }
            
            distOffset += distAccumulator
            timeOffset += timeAccumulator
        }
        
        let total = vector.reduce(0) { $0 + $1.distance}
        
        let median = total / Float(vector.count)
        
        
        
        
        let shifted = vector.map { (v) -> v_point in
            
            var copy = v
            copy.distance = v.distance - median
            
            
            return copy
        }
    
        
        return shifted
    }
    

}
