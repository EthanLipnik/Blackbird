//
//  BlurFilter.swift
//
//
//  Created by Ethan Lipnik on 10/4/19.
//

import UIKit

public struct BlurRing {
	var amount: NSNumber = 0
	var size: NSNumber = 0
}

public enum MaskParams {
	static let slope: CGFloat = 4.0
	static let width: CGFloat = 0.1
}

public extension UIImage {
	
	func applyingFilter(_ blurFilter: BlurFilter, radius: NSNumber? = nil, ring: BlurRing? = nil, softness: NSNumber? = nil, center: CIVector? = nil) -> UIImage? {
		
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
		
		guard let cgimg = Blackbird.shared.context.createCGImage(output, from: output.extent) else { return nil }
		
		let newImage = UIImage(cgImage: cgimg).scaling(toSize: self.size)
		
		return newImage
	}
}

public extension UIImageView {
	
	func applyFilter(_ blurFilter: BlurFilter, radius: NSNumber? = nil, ring: BlurRing? = nil, softness: NSNumber? = nil, center: CIVector? = nil) {
		
		self.image = self.image?.applyingFilter(blurFilter, radius: radius, ring: ring, softness: softness, center: center)
	}
}
