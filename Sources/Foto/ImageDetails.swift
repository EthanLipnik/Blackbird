//
//  ImageDetails.swift
//  
//
//  Created by Ethan Lipnik on 10/5/19.
//

#if !os(macOS)

import UIKit

extension UIImage {
	
	public func histogram() -> UIImage? {
		guard let beginImage = CIImage(image: self) else { return nil }
		
		guard let filter = CIFilter(name: "CIAreaHistogram") else { return nil }
		filter.setValue(beginImage, forKey: kCIInputImageKey)
		filter.setValue(256, forKey: "inputCount")
		filter.setValue(beginImage.extent, forKey: "inputExtent")
		filter.setValue(1.0, forKey: "inputScale")
		
		guard let histogramData = filter.outputImage else { return nil }
		
		guard let histogramFilter = CIFilter(name: "CIHistogramDisplayFilter") else { return nil }
		histogramFilter.setValue(histogramData, forKey: kCIInputImageKey)
		histogramFilter.setValue(200, forKey: "inputHeight")
		histogramFilter.setValue(0, forKey: "inputHighLimit")
		histogramFilter.setValue(0, forKey: "inputLowLimit")
		
		guard let finalHistogram = histogramFilter.outputImage else { return nil }
		
		return UIImage(ciImage: finalHistogram)
	}
}

#endif
