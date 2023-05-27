//
//  BlurFilter.swift
//
//
//  Created by Ethan Lipnik on 10/4/19.
//

#if os(macOS)
import AppKit
public typealias BBImage = NSImage
public typealias BBImageView = NSImageView
#else
import UIKit
public typealias BBImage = UIImage
public typealias BBImageView = UIImageView
#endif

public struct BlurRing {
    var amount: NSNumber = 0
    var size: NSNumber = 0
}

public enum MaskParams {
    static let slope: CGFloat = 4.0
    static let width: CGFloat = 0.1
}

public extension BBImage {
    func applyingFilter(
        _ blurFilter: BlurFilter,
        radius: NSNumber? = nil,
        mask: BBImage? = nil,
        ring: BlurRing? = nil,
        softness: NSNumber? = nil,
        center: CIVector? = nil
    ) -> BBImage? {
#if os(macOS)
        guard let beginImage = ciImage() else { return nil }
        let ciMask = mask?.ciImage()
#else
        guard let beginImage = CIImage(image: self) else { return nil }
        let ciMask: CIImage? = mask == nil ? nil : CIImage(image: mask!)
#endif

        guard let output = beginImage.applyingFilter(
            blurFilter,
            radius: radius,
            mask: (mask != nil) ? ciMask : nil,
            ring: ring,
            softness: softness,
            center: center
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
        _ blurFilter: BlurFilter,
        radius: NSNumber? = nil,
        mask: CIImage? = nil,
        ring: BlurRing? = nil,
        softness: NSNumber? = nil,
        center _: CIVector? = nil
    ) -> CIImage? {
        let crop = CIVector(
            x: 0,
            y: 0,
            z: extent.size.width,
            w: extent.size.height
        )

        guard let filter = CIFilter(name: blurFilter.rawValue) else { return nil }
        filter.setValue(self, forKey: "inputImage")
        if let radius {
            filter.setValue(radius, forKey: "inputRadius")
        }
        if let mask {
            filter.setValue(mask, forKey: "inputMask")
        }
        if let ring {
            filter.setValue(ring.amount, forKey: "inputRingAmount")
            filter.setValue(ring.size, forKey: "inputRingSize")
        }
        if let softness {
            filter.setValue(softness, forKey: "inputSoftness")
        }

        return filter.outputImage?.applyingFilter(
            "CICrop",
            parameters: ["inputRectangle": crop]
        )
    }
}

public extension BBImageView {
    func applyFilter(
        _ blurFilter: BlurFilter,
        radius: NSNumber? = nil,
        ring: BlurRing? = nil,
        softness: NSNumber? = nil,
        center: CIVector? = nil
    ) {
        image = image?.applyingFilter(
            blurFilter,
            radius: radius,
            ring: ring,
            softness: softness,
            center: center
        )
    }
}
