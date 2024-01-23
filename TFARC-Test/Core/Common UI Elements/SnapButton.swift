import UIKitPlus

class SnapButton: UIButton {

    private let idleImage: UIImage = .icSnapIdle
    private let pressedImage: UIImage = .icSnapPressed

    init() {
        super.init(frame: .zero)

        setImage(idleImage, for: .normal)
        setImage(pressedImage, for: .highlighted)
        setTitle(nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setImage(idleImage, for: .normal)
        setImage(pressedImage, for: .highlighted)
        setTitle(nil)
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.crossDissolve(with: self, duration: 0.2) {
                self.setImage(self.isHighlighted ? self.pressedImage : self.idleImage)
            }
        }
    }
}
