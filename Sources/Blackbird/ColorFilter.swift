//
//  ColorFilter.swift
//
//
//  Created by Ethan Lipnik on 10/4/19.
//

import UIKit

public extension UIImage {
	
	func applyingFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) -> UIImage? {
		
		guard let beginImage = CIImage(image: self) else { return nil }
		
		guard let output = beginImage.applyingFilter(colorFilter, intensity: intensity, ammount: ammount, radius: radius) else { return nil }
		
		guard let cgimg = Blackbird.shared.context.createCGImage(output, from: output.extent) else { return nil }
		
		let newImage = UIImage(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation).scaling(toSize: self.size)
		
		return newImage
	}
}

public extension CIImage {
	func applyingFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) -> CIImage? {
		
		guard let filter = CIFilter(name: colorFilter.rawValue) else { return nil }
		filter.setValue(self, forKey: "inputImage")
		if let intensity = intensity {
			filter.setValue(intensity, forKey: "inputIntensity")
		}
		if let ammount = ammount {
			if #available(iOS 12.0, *) {
				filter.setValue(ammount, forKey: "inputAmount")
			}
		}
		if let radius = radius {
			filter.setValue(radius, forKey: "inputRadius")
		}
		
		return filter.outputImage
	}
}

public extension UIImageView {
	
	func applyFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) {
		
		self.image = self.image?.applyingFilter(colorFilter, intensity: intensity, ammount: ammount, radius: radius)
	}
}
