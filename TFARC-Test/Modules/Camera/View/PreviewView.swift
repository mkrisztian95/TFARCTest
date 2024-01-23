import AVFoundation
import UIKit

class PreviewView: UIView {

    private var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError(
                       """
                        Expected `AVCaptureVideoPreviewLayer` type for layer.
                        Check PreviewView.layerClass implementation.
                       """
            )
        }
        return layer
    }

    var session: AVCaptureSession? {
        get {
            videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.session = newValue
        }
    }

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
}
