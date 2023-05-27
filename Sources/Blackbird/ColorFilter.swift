//
//  ColorFilter.swift
//
//
//  Created by Ethan Lipnik on 10/4/19.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension BBImage {
    func applyingFilter(
        _ colorFilter: ColorFilter,
        intensity: NSNumber? = nil,
        ammount: NSNumber? = nil,
        radius: NSNumber? = nil
    ) -> BBImage? {
        guard let beginImage = ciImage() else { return nil }

        guard let output = beginImage.applyingFilter(
            colorFilter,
            intensity: intensity,
            ammount: ammount,
            radius: radius
        ) else { return nil }

        guard let cgimg = CIContext().createCGImage(output, from: output.extent)
        else { return nil }

#if os(macOS)
        let newImage = BBImage(cgImage: cgimg, size: size)
#else
        let newImage = BBImage(cgImage: cgimg, scale: scale, orientation: imageOrientation)
            .scaling(toSize: size)
#endif

        return newImage
    }
}

public extension CIImage {
    func applyingFilter(
        _ colorFilter: ColorFilter,
        intensity: NSNumber? = nil,
        ammount: NSNumber? = nil,
        radius: NSNumber? = nil
    ) -> CIImage? {
        guard let filter = CIFilter(name: colorFilter.rawValue) else { return nil }
        filter.setValue(self, forKey: "inputImage")
        if let intensity {
            filter.setValue(intensity, forKey: "inputIntensity")
        }
        if let ammount {
            if #available(iOS 12.0, *) {
                filter.setValue(ammount, forKey: "inputAmount")
            }
        }
        if let radius {
            filter.setValue(radius, forKey: "inputRadius")
        }

        return filter.outputImage
    }
}

public extension BBImageView {
    func applyFilter(
        _ colorFilter: ColorFilter,
        intensity: NSNumber? = nil,
        ammount: NSNumber? = nil,
        radius: NSNumber? = nil
    ) {
        image = image?.applyingFilter(
            colorFilter,
            intensity: intensity,
            ammount: ammount,
            radius: radius
        )
    }
}
