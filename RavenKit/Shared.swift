//
//  Shared.swift
//  RavenKit
//
//  Created by Ethan Lipnik on 10/11/19.
//

import UIKit
import Blackbird

public extension UIImage {
	
	func applyingFilter(_ filter: RavenFilter) -> UIImage? {
		
		guard let segmentation = self.segmentation() else { return nil }
		
		switch filter {
		case .grayscale:
			
			let filter = GraySegmentFilter()
			filter.inputImage = CIImage.init(cgImage: self.cgImage!)
			filter.maskImage = CIImage.init(cgImage: segmentation)
			let output = filter.value(forKey: kCIOutputImageKey) as! CIImage
			
			let cgImage = Blackbird.shared.context.createCGImage(output, from: output.extent)!
			return UIImage(cgImage: cgImage)
		case .representation:
			
			return UIImage(cgImage: segmentation)
		}
	}
}
