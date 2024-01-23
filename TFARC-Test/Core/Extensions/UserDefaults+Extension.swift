import CustomizableAvatar
import Foundation
import UIKit

extension AvatarSource {
    init?(with dic: [String: Any]) {
        if dic["image"] != nil {
            if let data = dic["image"] as? Data,
               let decoded = try? PropertyListDecoder().decode(Data.self, from: data),
               let image = UIImage(data: decoded) {
                self = .image(image)
            } else {
                self = .image(.placeholder)
            }
        } else if let flag = dic["gradient_enabled"] as? Bool {
            if flag {
                self = .gradientColor(.init(
                    fontSize: UIFont.logoRegular.pointSize,
                    fontName: UIFont.logoRegular.fontName,
                    startColor: dic["startColor"] as? String ?? "",
                    endColor: dic["endColor"] as? String ?? "",
                    textColor: dic["textColor"] as? String ?? "",
                    name: dic["name"] as? String ?? ""
                ))
            } else {
                self = .solidColor(.init(
                    fontSize: UIFont.logoRegular.pointSize,
                    fontName: UIFont.logoRegular.fontName,
                    backgroundColor: dic["backgroundColor"] as? String ?? "",
                    textColor: dic["textColor"] as? String ?? "",
                    name: dic["name"] as? String ?? ""
                ))
            }
        } else {
            self = .image(.placeholder)
        }
    }
}

extension UserDefaults {
    private static let resourcesKey = "previousAvatarSources"

    func saveNewSource(_ source: AvatarSource) {
        currentSource = source
        var dic = [String: Any]()
        switch source {
        case .gradientColor(let source):
            dic["startColor"] = source.startColor
            dic["endColor"] = source.endColor
            dic["textColor"] = source.textColor
            dic["name"] = source.name
            dic["gradient_enabled"] = true

        case .solidColor(let source):
            dic["backgroundColor"] = source.backgroundColor
            dic["textColor"] = source.textColor
            dic["name"] = source.name
            dic["gradient_enabled"] = false
        case .image(let uIImage):
            if let data = uIImage.jpegData(compressionQuality: 0.5),
               let encoded = try? PropertyListEncoder().encode(data) {
                dic["image"] = encoded
            }
        }

        if var values = value(forKey: UserDefaults.resourcesKey) as? [[String: Any]] {
            values.append(dic)
            setValue(values, forKey: UserDefaults.resourcesKey)
        } else {
            setValue([dic], forKey: UserDefaults.resourcesKey)
        }
    }

    var currentSource: AvatarSource? {
        get {
            if let value = value(forKey: #function) as? [String: Any] {
                return AvatarSource(with: value)
            }
            return nil
        }

        set {
            var dic = [String: Any]()
            switch newValue {
            case .gradientColor(let source):
                dic["startColor"] = source.startColor
                dic["endColor"] = source.endColor
                dic["textColor"] = source.textColor
                dic["name"] = source.name
                dic["gradient_enabled"] = true

            case .solidColor(let source):
                dic["backgroundColor"] = source.backgroundColor
                dic["textColor"] = source.textColor
                dic["name"] = source.name
                dic["gradient_enabled"] = false
            case .image(let uIImage):
                if let data = uIImage.jpegData(compressionQuality: 0.5),
                    let encoded = try? PropertyListEncoder().encode(data) {
                    dic["image"] = encoded
                }
            case .none:
                break
            }
            setValue(dic, forKey: #function)
        }
    }

    var previousAvatarSources: [AvatarSource] {
        if let values = value(forKey: UserDefaults.resourcesKey) as? [[String: Any]] {
            return values.compactMap { AvatarSource(with: $0) }
        }

        return []
    }
}
