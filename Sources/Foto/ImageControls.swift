//
//  ImageControls.swift
//
//
//  Created by Ethan Lipnik on 10/4/19.
//

#if !os(macOS)
import UIKit

extension UIImage {
	
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
	
	public func clamped(_ components: Components) -> UIImage? {
		
		guard let beginImage = CIImage(image: self) else { return nil }
		
		guard let filter = CIFilter(name: "CIColorClamp") else { return nil }
		filter.setValue(beginImage, forKey: kCIInputImageKey)
		filter.setValue(components.max, forKey: "inputMaxComponents")
		filter.setValue(components.min, forKey: "inputMinComponents")
		
		guard let output = filter.outputImage else { return nil }
		
		let newImage = UIImage(ciImage: output)
		
		return newImage
	}
	
	public func adjusted(brightness: NSNumber = 0, contrast: NSNumber = 0, saturation: NSNumber = 0) -> UIImage? {
		guard let beginImage = CIImage(image: self) else { return nil }
		
		guard let filter = CIFilter(name: "CIColorControls") else { return nil }
		filter.setValue(beginImage, forKey: kCIInputImageKey)
		filter.setValue(brightness, forKey: kCIInputBrightnessKey)
		filter.setValue(contrast, forKey: kCIInputContrastKey)
		filter.setValue(saturation, forKey: kCIInputSaturationKey)
		
		guard let output = filter.outputImage else { return nil }
		
		let newImage = UIImage(ciImage: output)
		
		return newImage
	}
	
	public func adjustedPolynomial(_ coefficients: ColorCoefficients) -> UIImage? {
		guard let beginImage = CIImage(image: self) else { return nil }
		
		guard let filter = CIFilter(name: "CIColorControls") else { return nil }
		filter.setValue(beginImage, forKey: kCIInputImageKey)
		filter.setValue(coefficients.alpha, forKey: "inputAlphaCoefficients")
		filter.setValue(coefficients.blue, forKey: "inputBlueCoefficients")
		filter.setValue(coefficients.green, forKey: "inputGreenCoefficients")
		filter.setValue(coefficients.red, forKey: "inputRedCoefficients")
		
		guard let output = filter.outputImage else { return nil }
		
		let newImage = UIImage(ciImage: output)
		
		return newImage
	}
}
#endif
