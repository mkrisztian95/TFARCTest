import UIKit

class RoundedButton: UIButton {

    var accentColor: UIColor = .clear {
        didSet {
            colorizeAnimated()
        }
    }

    var accentDisabledColor: UIColor = .black300 {
        didSet {
            colorizeAnimated()
        }
    }

    var titleEnabledFilledColor: UIColor = .constantWhite {
        didSet {
            colorizeAnimated()
        }
    }

    var titleDisabledFilledColor: UIColor = .constantWhite {
        didSet {
            colorizeAnimated()
        }
    }

    var borderWidth: CGFloat = 0 {
        didSet {
            colorizeAnimated()
        }
    }

    var isFilled = false {
        didSet {
            colorizeAnimated()
        }
    }

    override var isEnabled: Bool {
        get {
            super.isEnabled
        }
        set {
            super.isEnabled = newValue
            colorizeAnimated()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        colorize()
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        colorize()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.midY
    }

    func setup() {}

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        colorizeAnimated()
    }
}

extension RoundedButton: Colorizable {

    private func colorizeAnimated() {
        UIView.animate(withDuration: 0.3) {
            self.colorize()
        }
    }

    func colorize() {
        layer.borderColor = isFilled ? UIColor.clear.cgColor : accentColor.cgColor
        layer.borderWidth = borderWidth

        backgroundColor = isFilled
            ? (isEnabled ? accentColor : accentDisabledColor)
            : .clear

        setTitleColor(
            isFilled
                ? (isEnabled ? titleEnabledFilledColor : titleDisabledFilledColor)
                : accentColor,
            for: .normal
        )

        tintColor = isFilled
            ? (isEnabled ? titleEnabledFilledColor : titleDisabledFilledColor)
            : accentColor
    }
}

protocol Colorizable {
    func colorize()
}
