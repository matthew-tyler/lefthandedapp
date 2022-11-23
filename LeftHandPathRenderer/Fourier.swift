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
    
    /**
    func transform(_ vector: [v_point]) -> [Float] {
        
        var real : [Float] = [1.0,2.0,3.0,4.0]
       
        
        var padded = padSignal(vector)
        
//        let signal = padded.map{$0.distance}
        let signal = real;
        
        let n = vDSP_Length(signal.count)
        
//         Interleved
//        log2n = vDSP_Length(log2(Float(n)))
        
//        //Non interleved
        log2n = vDSP_Length(ceil(log2(Float(n * 2))))

       
        // FFTRadix(kFFTRadix2)
            
        if (fftSetUp == nil){

            fftSetUp = vDSP.FFT(log2n: log2n!, radix: .radix2, ofType: DSPSplitComplex.self)
        }
        
        // interleved
//        let halfN = Int(log2n! / 2)
        
        // Non interleved
        let halfN = Int(n);
                
        var forwardInputReal = [Float](signal)
        var forwardInputImag = [Float](repeating: 0,
                                       count: halfN)
        var forwardOutputReal = [Float](repeating: 0,
                                        count: halfN)
        var forwardOutputImag = [Float](repeating: 0,
                                        count: halfN)
        
        var magnitudes = [Float](repeating: 0, count: Int(signal.count))
        
        
        forwardInputReal.withUnsafeMutableBufferPointer { forwardInputRealPtr in
            forwardInputImag.withUnsafeMutableBufferPointer { forwardInputImagPtr in
                forwardOutputReal.withUnsafeMutableBufferPointer { forwardOutputRealPtr in
                    forwardOutputImag.withUnsafeMutableBufferPointer { forwardOutputImagPtr in
                        
                        // Create a `DSPSplitComplex` to contain the signal.
                        var forwardInput = DSPSplitComplex(realp: forwardInputRealPtr.baseAddress!,
                                                           imagp: forwardInputImagPtr.baseAddress!)
                        
//                        // Convert the real values in `signal` to complex numbers.
//                        signal.withUnsafeBytes {
//                            vDSP.convert(interleavedComplexVector: [DSPComplex]($0.bindMemory(to: DSPComplex.self)),
//                                         toSplitComplexVector: &forwardInput)
//                        }
//
                        

                        // Create a `DSPSplitComplex` to receive the FFT result.
                        var forwardOutput = DSPSplitComplex(realp: forwardOutputRealPtr.baseAddress!,
                                                            imagp: forwardOutputImagPtr.baseAddress!)
                        
//                        // Perform the forward FFT.
//                        fftSetUp!.forward(input: forwardInput,
//                                         output: &forwardOutput)
//
                        
//
//
//                        conjOutput = vDSP.conjugate(forwardOutput, count: <#T##Int#>, result: &<#T##DSPSplitComplex#>)
//
//                        ( forwardOutput+conjOuput ) /2
                        let rel = Array(UnsafeBufferPointer(start: forwardOutput.realp, count: signal.count))
                        
                        let imag = Array(UnsafeBufferPointer(start: forwardOutput.imagp, count: signal.count))
                        
                        
                        print("imag = " + imag.description)
                        
              
                        vDSP.absolute(forwardOutput, result: &magnitudes)
                        
                        
                        
                    }
                }
            }
        }
        
        
        print("real= " + forwardOutputReal.description)
        
        
        print("magnitudes = " + magnitudes.description);
        
        return magnitudes
        
    }
    
    
     */
    
    func transform(_ vector: [v_point]) -> [Float] {
        
        
        var padded = padSignal(vector)
        
        
        
        
        var signal = padded.map{$0.distance}
        
        signal = signal [..<200].map{$0}
        
//        signal = [0.0,5,0.0,5.0,0.0,5.0,0.0,5.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        
        print(signal.count)
//
//
//        var timeDomainBuffer = [Float](repeating: 0, count: signal.count)
//        var frequencyDomainBuffer = [Float](repeating: 0, count: signal.count)
//
//        let forwardDCT = vDSP.DCT(count: signal.count, transformType: .II)!
//
//
//       forwardDCT.transform(timeDomainBuffer, result: &frequencyDomainBuffer)
//
//        vDSP.absolute(frequencyDomainBuffer, result: &frequencyDomainBuffer)
//
//        print(frequencyDomainBuffer)
//
//        signal = [1.0,2.0,3.0,4.0]
        
        
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



        let output = UnsafeMutablePointer<Float>.allocate(capacity: frameCount)


        vDSP_zvmags(
              &complexBuffer,
            1,
             output,
             1,
              vDSP_Length((frameCount / 2))
        )
        
        var mags = Array<Float>(repeating: 0, count: frameCount)
        _ = mags.withContiguousMutableStorageIfAvailable {
          UnsafeMutableRawPointer($0.baseAddress!).copyMemory(from: output, byteCount: MemoryLayout<Float>.size * frameCount)
        }

        var realFloats = Array(reals)
        var imaginaryFloats = Array(imags)
        
   
        print(mags)


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
