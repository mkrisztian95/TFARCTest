import UIKit

class PrimaryButton: RoundedButton {
    override func setup() {
        isFilled = true
        accentColor = .primary500
        accentDisabledColor = .black300
        titleEnabledFilledColor = .constantWhite
        titleDisabledFilledColor = .black600
        titleLabel?.font = .titleSemiBold
    }

    func fixed() -> Self {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56)
        ])

        return self
    }
}
