import UIKitPlus

class CloseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        let image = UIImage.icClose.withRenderingMode(.alwaysTemplate)
        setImage(image)
        setTitle("")
        setTitleColor(.black900)
        tintColor = .black900
        imageView?.contentMode = .scaleAspectFit
    }
}
