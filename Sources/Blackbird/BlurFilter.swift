//
//  BlurFilter.swift
//
//
//  Created by Ethan Lipnik on 10/4/19.
//

import Foundation

public struct BlurRing {
	var amount: NSNumber = 0
	var size: NSNumber = 0
}

#if !os(macOS)

import UIKit

public extension UIImage {
	
	func appliedFilter(_ blurFilter: BlurFilter, radius: NSNumber? = nil, ring: BlurRing? = nil, softness: NSNumber? = nil, center: CIVector? = nil) -> UIImage? {
		
		guard let beginImage = CIImage(image: self) else { return nil }
		
		guard let filter = CIFilter(name: blurFilter.rawValue) else { return nil }
		filter.setValue(beginImage, forKey: kCIInputImageKey)
		if let radius = radius {
			filter.setValue(radius, forKey: kCIInputRadiusKey)
		}
		if let ring = ring {
			filter.setValue(ring.amount, forKey: "inputRingAmount")
			filter.setValue(ring.size, forKey: "inputRingSize")
		}
		if let softness = softness {
			filter.setValue(softness, forKey: "inputSoftness")
		}
		
		guard let output = filter.outputImage else { return nil }
		
		let newImage = UIImage(ciImage: output)
		
		return newImage
	}
}

public extension UIImageView {
	
	func applyFilter(_ blurFilter: BlurFilter, radius: NSNumber? = nil, ring: BlurRing? = nil, softness: NSNumber? = nil, center: CIVector? = nil) {
		
		self.image = self.image?.appliedFilter(blurFilter, radius: radius, ring: ring, softness: softness, center: center)
	}
}

#else

import AppKit

public extension NSImage {
	
	public func appliedFilter(_ blurFilter: BlurFilter, radius: NSNumber? = nil, ring: BlurRing? = nil, softness: NSNumber? = nil, center: CIVector? = nil) -> NSImage? {
		
		guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
		
		let beginImage = CIImage(cgImage: cgImage)
		
		guard let filter = CIFilter(name: blurFilter.rawValue) else { return nil }
		filter.setValue(beginImage, forKey: kCIInputImageKey)
		if let radius = radius {
			filter.setValue(radius, forKey: kCIInputRadiusKey)
		}
		if let ring = ring {
			filter.setValue(ring.amount, forKey: "inputRingAmount")
			filter.setValue(ring.size, forKey: "inputRingSize")
		}
		if let softness = softness {
			filter.setValue(softness, forKey: "inputSoftness")
		}
		
		guard let output = filter.outputImage else { return nil }
		
		let rep = NSCIImageRep(ciImage: output)
		let nsImage = NSImage(size: rep.size)
		nsImage.addRepresentation(rep)
		
		return nsImage
	}
}

public extension NSImageView {
	
	public func applyFilter(_ blurFilter: BlurFilter, radius: NSNumber? = nil, ring: BlurRing? = nil, softness: NSNumber? = nil, center: CIVector? = nil) {
		
		self.image = self.image?.appliedFilter(blurFilter, radius: radius, ring: ring, softness: softness, center: center)
	}
}

#endif
