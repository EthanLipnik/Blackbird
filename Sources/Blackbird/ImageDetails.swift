//
//  ImageDetails.swift
//
//
//  Created by Ethan Lipnik on 10/5/19.
//

#if os(macOS)
import AppKit.NSImage
#else
import UIKit.UIImage
#endif

public extension BBImage {
    func histogram(withHeight height: NSNumber = 256) -> BBImage? {
        guard let beginImage = ciImage() else { print("No image to proccess")
            return nil
        }

        guard let filter = CIFilter(name: "CIAreaHistogram")
        else { print("Failed to create the histogram filter")
            return nil
        }
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filter.setValue(256, forKey: "inputCount")
        filter.setValue(beginImage.extent, forKey: "inputExtent")
        filter.setValue(1.0, forKey: "inputScale")

        guard let histogramData = filter.outputImage else { print("Failed to get histogram data")
            return nil
        }

        guard let histogramFilter = CIFilter(name: "CIHistogramDisplayFilter")
        else { print("Failed to create histogram display filter")
            return nil
        }
        histogramFilter.setValue(histogramData, forKey: kCIInputImageKey)
        histogramFilter.setValue(height, forKey: "inputHeight")

        guard let output = histogramFilter.outputImage
        else { print("Failed to get histogram output")
            return nil
        }

        guard let cgimg = CIContext().createCGImage(output, from: output.extent)
        else { return nil }

#if os(macOS)
        return BBImage(cgImage: cgimg, size: size)
#else
        return BBImage(cgImage: cgimg)
#endif
    }

    func ciImage() -> CIImage? {
#if os(macOS)
        guard let data = tiffRepresentation else { return nil }
        return CIImage(data: data)
#else
        return CIImage(image: self) ?? ciImage
#endif
    }
}
