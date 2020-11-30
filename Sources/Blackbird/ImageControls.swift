//
//  ImageControls.swift
//
//
//  Created by Ethan Lipnik on 10/4/19.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public struct Components {
    var max: CIVector
    var min: CIVector
}

public struct ColorCoefficients {
    var alpha: CIVector
    var blue: CIVector
    var green: CIVector
    var red: CIVector
}

public extension BBImage {
    
    func clamping(_ components: Components) -> BBImage? {
        guard let beginImage = self.ciImage() else { return nil }
        
        guard let filter = CIFilter(name: "CIColorClamp") else { return nil }
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filter.setValue(components.max, forKey: "inputMaxComponents")
        filter.setValue(components.min, forKey: "inputMinComponents")
        
        guard let output = filter.outputImage else { return nil }
        
        guard let cgimg = Blackbird.shared.context.createCGImage(output, from: output.extent) else { return nil }
        #if os(macOS)
        let newImage = BBImage(cgImage: cgimg, size: self.size)
        #else
        let newImage = BBImage(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation).scaling(toSize: self.size)
        #endif
        
        return newImage
    }
    
    func adjusting(brightness: NSNumber?, contrast: NSNumber?, saturation: NSNumber?) -> BBImage? {
        
        guard let beginImage = self.ciImage() else { return nil }
        
        guard let output = beginImage.adjusting(brightness: brightness, contrast: contrast, saturation: saturation) else { return nil }
        
        guard let cgimg = Blackbird.shared.context.createCGImage(output, from: output.extent) else { return nil }
        
        #if os(macOS)
        let newImage = BBImage(cgImage: cgimg, size: self.size)
        #else
        let newImage = BBImage(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation).scaling(toSize: self.size)
        #endif
        
        return newImage
    }
    
    func adjusting(_ coefficients: ColorCoefficients) -> BBImage? {
        guard let beginImage = self.ciImage() else { return nil }
        
        guard let output = beginImage.adjusting(coefficients) else { return nil }
        
        guard let cgimg = Blackbird.shared.context.createCGImage(output, from: output.extent) else { return nil }
        
        #if os(macOS)
        let newImage = BBImage(cgImage: cgimg, size: self.size)
        #else
        let newImage = BBImage(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation).scaling(toSize: self.size)
        #endif
        
        return newImage
    }
    
    #if !os(macOS)
    func scaling(toSize size: CGSize) -> BBImage {
        
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage : BBImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    #endif
}

public extension CIImage {
    
    func adjusting(_ coefficients: ColorCoefficients) -> CIImage? {
        
        guard let filter = CIFilter(name: "CIColorPolynomial") else { return nil }
        filter.setValue(self, forKey: kCIInputImageKey)
        filter.setValue(coefficients.alpha, forKey: "inputAlphaCoefficients")
        filter.setValue(coefficients.blue, forKey: "inputBlueCoefficients")
        filter.setValue(coefficients.green, forKey: "inputGreenCoefficients")
        filter.setValue(coefficients.red, forKey: "inputRedCoefficients")
        
        return filter.outputImage
    }
    
    func adjusting(brightness: NSNumber?, contrast: NSNumber?, saturation: NSNumber?) -> CIImage? {
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(self, forKey: kCIInputImageKey)
        
        if let brightness = brightness {
            filter?.setValue(brightness, forKey: kCIInputBrightnessKey)
        }
        
        if let contrast = contrast {
            filter?.setValue(contrast, forKey: kCIInputContrastKey)
        }
        
        if let saturation = saturation {
            filter?.setValue(saturation, forKey: kCIInputSaturationKey)
        }
        
        return filter?.outputImage
    }
}
