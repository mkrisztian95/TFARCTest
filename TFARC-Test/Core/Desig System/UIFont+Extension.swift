import os
import UIKit

extension UIFont {

    static var bodyBold: UIFont {
        customFont("SomeAwesome_to_find-Bold", size: 15.0)
    }

    static var bodyLight: UIFont {
        customFont("SomeAwesome_to_find-Light", size: 15.0)
    }

    static var bodyRegular: UIFont {
        customFont("SomeAwesome_to_find-Regular", size: 15.0)
    }

    static var bodySemiBold: UIFont {
        customFont("SomeAwesome_to_find-Semibold", size: 15.0)
    }

    static var captionLBold: UIFont {
        customFont("SomeAwesome_to_find-Bold", size: 13.0)
    }

    static var captionLLight: UIFont {
        customFont("SomeAwesome_to_find-Light", size: 13.0)
    }

    static var captionLMedium: UIFont {
        customFont("SomeAwesome_to_find-Medium", size: 13.0)
    }

    static var captionLRegular: UIFont {
        customFont("SomeAwesome_to_find-Regular", size: 13.0)
    }

    static var captionMBold: UIFont {
        customFont("SomeAwesome_to_find-Bold", size: 11.0)
    }

    static var captionMMedium: UIFont {
        customFont("SomeAwesome_to_find-Medium", size: 11.0)
    }

    static var captionMRegular: UIFont {
        customFont("SomeAwesome_to_find-Regular", size: 11.0)
    }

    static var captionSBold: UIFont {
        customFont("SomeAwesome_to_find-Bold", size: 9.0)
    }

    static var captionSMedium: UIFont {
        customFont("SomeAwesome_to_find-Medium", size: 9.0)
    }

    static var captionSRegular: UIFont {
        customFont("SomeAwesome_to_find-Regular", size: 9.0)
    }

    static var headingsH1Bold: UIFont {
        customFont("SomeAwesome_to_find-Bold", size: 36.0)
    }

    static var headingsH2Bold: UIFont {
        customFont("SomeAwesome_to_find-Bold", size: 26.0)
    }

    static var headingsH2SemiBold: UIFont {
        customFont("SomeAwesome_to_find-Semibold", size: 26.0)
    }

    static var headingsH3Bold: UIFont {
        customFont("SomeAwesome_to_find-Bold", size: 24.0)
    }

    static var headingsH3SemiBold: UIFont {
        customFont("SomeAwesome_to_find-Semibold", size: 24.0)
    }

    static var headingsH4Bold: UIFont {
        customFont("SomeAwesome_to_find-Bold", size: 20.0)
    }

    static var headingsH4SemiBold: UIFont {
        customFont("SomeAwesome_to_find-Bold", size: 20.0)
    }

    static var titleMedium: UIFont {
        customFont("SomeAwesome_to_find-Medium", size: 17.0)
    }

    static var titleRegular: UIFont {
        customFont("SomeAwesome_to_find-Regular", size: 17.0)
    }

    static var logoRegular: UIFont {
        customFont("SomeAwesome_to_find-Regular", size: 32.0)
    }

    static var titleSemiBold: UIFont {
        customFont("", size: 17.0)
    }

    private static func customFont(
        _ name: String,
        size: CGFloat,
        textStyle: UIFont.TextStyle? = nil,
        scaled: Bool = false
    ) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }

        if scaled, let textStyle = textStyle {
            let metrics = UIFontMetrics(forTextStyle: textStyle)
            return metrics.scaledFont(for: font)
        } else {
            return font
        }
    }
}
