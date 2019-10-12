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
		
		guard let filter = CIFilter(name: colorFilter.rawValue) else { return nil }
		filter.setValue(beginImage, forKey: kCIInputImageKey)
		if let intensity = intensity {
			filter.setValue(intensity, forKey: kCIInputIntensityKey)
		}
		if let ammount = ammount {
			if #available(iOS 12.0, *) {
				filter.setValue(ammount, forKey: kCIInputAmountKey)
			}
		}
		if let radius = radius {
			filter.setValue(radius, forKey: kCIInputRadiusKey)
		}
		
		guard let output = filter.outputImage else { return nil }
		
		guard let cgimg = Blackbird.shared.context.createCGImage(output, from: output.extent) else { return nil }
		
		let newImage = UIImage(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation).scaling(toSize: self.size)
		
		return newImage
	}
}

public extension UIImageView {
	
	func applyFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) {
		
		self.image = self.image?.applyingFilter(colorFilter, intensity: intensity, ammount: ammount, radius: radius)
	}
}
