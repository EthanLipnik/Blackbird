import AVFoundation
import MetalKit
import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

open class UIBlackbirdView: MTKView, MTKViewDelegate {
    public let colorSpace = CGColorSpaceCreateDeviceRGB()

    public lazy var commandQueue: MTLCommandQueue? = {
        [unowned self] in

        if device == nil {
            device = MTLCreateSystemDefaultDevice()
        }

        return device?.makeCommandQueue()
    }()

    public lazy var ciContext: CIContext = {
        [unowned self] in

        if device == nil {
            device = MTLCreateSystemDefaultDevice()
        }

        let context = CIContext(
            mtlDevice: device!,
            options: [
                CIContextOption.highQualityDownsample: true,
                CIContextOption.priorityRequestLow: false
            ]
        )

        return context
    }()

    public lazy var image: CIImage? = nil {
        didSet {
            draw(in: self)
        }
    }

    public init() {
        super.init(frame: .zero, device: MTLCreateSystemDefaultDevice())
        setup()
    }

    override public init(
        frame frameRect: CGRect,
        device: MTLDevice? = MTLCreateSystemDefaultDevice()
    ) {
        super.init(
            frame: frameRect,
            device: device ?? MTLCreateSystemDefaultDevice()
        )

        if super.device == nil {
            fatalError("Device doesn't support Metal")
        }

        setup()
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        device = MTLCreateSystemDefaultDevice()
        setup()
    }

    private func setup() {
        isPaused = true
        enableSetNeedsDisplay = true
        framebufferOnly = false

        delegate = self
    }

    public func mtkView(_: MTKView, drawableSizeWillChange _: CGSize) {
        // tells us the drawable's size has changed
    }

    public func draw(in view: MTKView) {
        // create command buffer for ciContext to use to encode it's rendering instructions to our
        // GPU
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else {
            return
        }

        // make sure we actually have a ciImage to work with
        guard let ciImage = image else {
            return
        }

        // make sure the current drawable object for this metal view is available (it's not in use
        // by the previous draw cycle)
        guard let currentDrawable = view.currentDrawable else {
            return
        }

        let bounds = CGRect(origin: CGPoint.zero, size: drawableSize)

        let originX = ciImage.extent.origin.x
        let originY = ciImage.extent.origin.y

        let scaleX = view.drawableSize.width / ciImage.extent.width
        let scaleY = view.drawableSize.height / ciImage.extent.height
        let scale = min(scaleX, scaleY)

        let scaledImage = ciImage
            .transformed(by: CGAffineTransform(translationX: -originX, y: -originY))
            .transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        // render into the metal texture
        ciContext.render(
            scaledImage,
            to: currentDrawable.texture,
            commandBuffer: commandBuffer,
            bounds: bounds,
            colorSpace: colorSpace
        )

        // register where to draw the instructions in the command buffer once it executes
        commandBuffer.present(currentDrawable)
        // commit the command to the queue so it executes
        commandBuffer.commit()
    }
}

#if os(macOS)
public struct BlackbirdView: NSViewRepresentable {
    @Binding
    public var image: CIImage

    public init(image: Binding<CIImage>) {
        _image = image
    }

    public func makeNSView(context _: Context) -> UIBlackbirdView {
        let view = UIBlackbirdView()
        view.image = image
        return view
    }

    public func updateNSView(_ nsView: UIBlackbirdView, context _: Context) {
        nsView.image = image
    }
}
#else
public struct BlackbirdView: UIViewRepresentable {
    @Binding
    public var image: CIImage

    public init(image: Binding<CIImage>) {
        _image = image
    }

    public func makeUIView(context _: Context) -> UIBlackbirdView {
        let view = UIBlackbirdView()
        view.image = image
        return view
    }

    public func updateUIView(_ uiView: UIBlackbirdView, context _: Context) {
        uiView.image = image
    }
}
#endif
