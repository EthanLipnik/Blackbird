//
//  ColorFilter.swift
//  Foto SDK
//
//  Created by Ethan Lipnik on 10/4/19.
//  Copyright © 2019 Tailosive. All rights reserved.
//

#if !os(macOS)

import UIKit

extension UIImage {
	
	func fotoAppliedFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) -> UIImage? {
		
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
		
		let newImage = UIImage(ciImage: output)
		
		return newImage
	}
}

extension UIImageView {
	
	func fotoApplyFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) {
		
		self.image = self.image?.fotoAppliedFilter(colorFilter, intensity: intensity, ammount: ammount, radius: radius)
	}
}

#else

import AppKit

extension NSImage {
	
	func fotoAppliedFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) -> NSImage? {
		
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

extension NSImageView {
	
	func fotoApplyFilter(_ colorFilter: ColorFilter, intensity: NSNumber? = nil, ammount: NSNumber? = nil, radius: NSNumber? = nil) {
		
		self.image = self.image?.fotoAppliedFilter(colorFilter, intensity: intensity, ammount: ammount, radius: radius)
	}
}

#endif
