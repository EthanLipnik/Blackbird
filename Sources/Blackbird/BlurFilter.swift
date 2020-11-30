//
//  BlurFilter.swift
//
//
//  Created by Ethan Lipnik on 10/4/19.
//

#if os(macOS)
import AppKit
public typealias Image = NSImage
public typealias ImageView = NSImageView
#else
import UIKit
public typealias Image = UIImage
public typealias ImageView = UIImageView
#endif

public struct BlurRing {
    var amount: NSNumber = 0
    var size: NSNumber = 0
}

public enum MaskParams {
    static let slope: CGFloat = 4.0
    static let width: CGFloat = 0.1
}

public extension Image {
    
    func applyingFilter(_ blurFilter: BlurFilter, radius: NSNumber? = nil, mask: Image? = nil, ring: BlurRing? = nil, softness: NSNumber? = nil, center: CIVector? = nil) -> Image? {
        
        #if os(macOS)
        guard let beginImage = self.ciImage() else { return nil }
        let ciMask = mask?.ciImage()
        #else
        guard let beginImage = CIImage(image: self) else { return nil }
        let ciMask: CIImage? = mask == nil ? nil : CIImage(image: mask!)
        #endif
        
        guard let output = beginImage.applyingFilter(blurFilter, radius: radius, mask: (mask != nil) ? ciMask : nil, ring: ring, softness: softness, center: center) else { return nil }
        
        guard let cgimg = Blackbird.shared.context.createCGImage(output, from: output.extent) else { return nil }
        
        #if os(macOS)
        let newImage = Image(cgImage: cgimg, size: self.size)
        #else
        let newImage = Image(cgImage: cgimg, scale: self.scale, orientation: self.imageOrientation).scaling(toSize: self.size)
        #endif
        
        return newImage
    }
}

public extension CIImage {
    
    func applyingFilter(_ blurFilter: BlurFilter, radius: NSNumber? = nil, mask: CIImage? = nil, ring: BlurRing? = nil, softness: NSNumber? = nil, center: CIVector? = nil) -> CIImage? {
        
        let crop = CIVector(x: 0,
                            y: 0,
                            z: self.extent.size.width,
                            w: self.extent.size.height)
        
        guard let filter = CIFilter(name: blurFilter.rawValue) else { return nil }
        filter.setValue(self, forKey: "inputImage")
        if let radius = radius {
            filter.setValue(radius, forKey: "inputRadius")
        }
        if let mask = mask {
            filter.setValue(mask, forKey: "inputMask")
        }
        if let ring = ring {
            filter.setValue(ring.amount, forKey: "inputRingAmount")
            filter.setValue(ring.size, forKey: "inputRingSize")
        }
        if let softness = softness {
            filter.setValue(softness, forKey: "inputSoftness")
        }
        
        return filter.outputImage?.applyingFilter("CICrop",
                                                  parameters: ["inputRectangle": crop])
    }
}

public extension ImageView {
    
    func applyFilter(_ blurFilter: BlurFilter, radius: NSNumber? = nil, ring: BlurRing? = nil, softness: NSNumber? = nil, center: CIVector? = nil) {
        
        self.image = self.image?.applyingFilter(blurFilter, radius: radius, ring: ring, softness: softness, center: center)
    }
}
