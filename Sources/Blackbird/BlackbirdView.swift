import SwiftUI
import MetalKit
import AVFoundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

open class UIBlackbirdView: MTKView {
    
    public let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    public lazy var commandQueue: MTLCommandQueue = {
        [unowned self] in
        
        if self.device == nil {
            self.device = MTLCreateSystemDefaultDevice()
        }
        
        return self.device!.makeCommandQueue()!
    }()
    
    public lazy var ciContext: CIContext = {
        [unowned self] in
        
        if self.device == nil {
            self.device = MTLCreateSystemDefaultDevice()
        }
        
        let context = CIContext(mtlDevice: self.device!, options: [CIContextOption.highQualityDownsample: true, CIContextOption.priorityRequestLow: false])
        
        return context
    }()
    
    public override init(frame frameRect: CGRect, device: MTLDevice? = MTLCreateSystemDefaultDevice()) {
        super.init(frame: frameRect,
                   device: device ?? MTLCreateSystemDefaultDevice())
        
        if super.device == nil
        {
            fatalError("Device doesn't support Metal")
        }
        
        self.framebufferOnly = false
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.framebufferOnly = false
        
        self.device = MTLCreateSystemDefaultDevice()
    }
    
    /// The image to display
    public var image: CIImage?
    {
        didSet
        {
            
            self.drawableSize = image?.extent.size ?? self.drawableSize
            
            renderImage()
        }
    }
    
    public var orientation: CGImagePropertyOrientation? {
        didSet {
            
            renderImage()
        }
    }
    
    func renderImage()
    {
        
        guard var
                image = self.image,
              let targetTexture = self.currentDrawable?.texture else
        {
            print("No texture/image")
            return
        }
        
        if let orientation = orientation {
            image = image.oriented(orientation)
        }
        
        let commandBuffer = self.commandQueue.makeCommandBuffer()
        
        let bounds = CGRect(origin: CGPoint.zero, size: self.drawableSize)
        
        let originX = image.extent.origin.x
        let originY = image.extent.origin.y
        
        let scaleX = self.drawableSize.width / image.extent.width
        let scaleY = self.drawableSize.height / image.extent.height
        let scale = min(scaleX, scaleY)
        
        let scaledImage = image
            .transformed(by: CGAffineTransform(translationX: -originX, y: -originY))
            .transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        self.ciContext.render(scaledImage,
                              to: targetTexture,
                              commandBuffer: commandBuffer,
                              bounds: bounds,
                              colorSpace: self.colorSpace)
        
        commandBuffer?.present(self.currentDrawable!)
        
        commandBuffer?.commit()
        
        self.draw()
        
        self.releaseDrawables()
    }
}

#if os(macOS)
public struct BlackbirdView: NSViewRepresentable {
    @Binding public var image: CIImage
    
    public init(image: Binding<CIImage>) {
        self._image = image
    }
    
    public func makeNSView(context: Context) -> UIBlackbirdView {
        let view = UIBlackbirdView()
        view.image = image
        return view
    }
    
    public func updateNSView(_ nsView: UIBlackbirdView, context: Context) {
        nsView.image = image
    }
}
#else
public struct BlackbirdView: UIViewRepresentable {
    @Binding public var image: CIImage
    
    public init(image: Binding<CIImage>) {
        self._image = image
    }
    
    public func makeUIView(context: Context) -> UIBlackbirdView {
        let view = UIBlackbirdView()
        view.image = image
        return view
    }
    
    public func updateUIView(_ uiView: UIBlackbirdView, context: Context) {
        uiView.image = image
    }
}
#endif
