import UIKitPlus

class BackButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        let image = UIImage.icBack.withRenderingMode(.alwaysTemplate)
        setImage(image)
        setTitle("")
        imageView?.contentMode = .scaleAspectFit
    }
}
