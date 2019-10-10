//
//  ColorFilter.swift
//
//
//  Created by Ethan Lipnik on 10/4/19.
//

#if !os(macOS)

import UIKit

public extension UIImage {
	
	func appliedFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) -> UIImage? {
		
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
		
		let newImage = UIImage(cgImage: cgimg).scaled(toSize: self.size)
		
		return newImage
	}
}

public extension UIImageView {
	
	func applyFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) {
		
		self.image = self.image?.appliedFilter(colorFilter, intensity: intensity, ammount: ammount, radius: radius)
	}
}

#else

import AppKit

public extension NSImage {
	
	func appliedFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) -> NSImage? {
		
		guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
		
		let beginImage = CIImage(cgImage: cgImage)
		
		guard let filter = CIFilter(name: colorFilter.rawValue) else { return nil }
		filter.setValue(beginImage, forKey: kCIInputImageKey)
		if let intensity = intensity {
			filter.setValue(intensity, forKey: kCIInputIntensityKey)
		}
		if let ammount = ammount {
			if #available(OSX 10.14, *) {
				filter.setValue(ammount, forKey: kCIInputAmountKey)
			}
		}
		if let radius = radius {
			filter.setValue(radius, forKey: kCIInputRadiusKey)
		}
		
		guard let output = filter.outputImage else { return nil }
		
		let rep = NSCIImageRep(ciImage: output)
		let nsImage = NSImage(size: rep.size)
		nsImage.addRepresentation(rep)
		
		return nsImage
	}
}

public extension NSImageView {
	
	func applyFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) {
		
		self.image = self.image?.appliedFilter(colorFilter, intensity: intensity, ammount: ammount, radius: radius)
	}
}

#endif
