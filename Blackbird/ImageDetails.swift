//
//  ImageDetails.swift
//  
//
//  Created by Ethan Lipnik on 10/5/19.
//

#if !os(macOS)

import UIKit

extension UIImage {
	
	public func histogram(withHeight height: NSNumber = 256) -> UIImage? {
		
		guard let beginImage = self.ciImage() else { print("No image to proccess"); return nil }
		
		guard let filter = CIFilter(name: "CIAreaHistogram") else { print("Failed to create the histogram filter"); return nil }
		filter.setValue(beginImage, forKey: kCIInputImageKey)
		filter.setValue(256, forKey: "inputCount")
		filter.setValue(beginImage.extent, forKey: "inputExtent")
		filter.setValue(1.0, forKey: "inputScale")
		
		guard let histogramData = filter.outputImage else { print("Failed to get histogram data"); return nil }
		
		guard let histogramFilter = CIFilter(name: "CIHistogramDisplayFilter") else { print("Failed to create histogram display filter"); return nil }
		histogramFilter.setValue(histogramData, forKey: kCIInputImageKey)
		histogramFilter.setValue(height, forKey: "inputHeight")
		
		guard let output = histogramFilter.outputImage else { print("Failed to get histogram output"); return nil }
		
		guard let cgimg = Blackbird.shared.context.createCGImage(output, from: output.extent) else { return nil }
		
		return UIImage(cgImage: cgimg)
	}
	
	public func ciImage() -> CIImage? {
		
		return CIImage(image: self) ?? self.ciImage
	}
}

#endif
