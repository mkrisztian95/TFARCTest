import CombinePlus
import Depin
import UIKit
import XCoordinator
import CustomizableAvatar

class UserProfileViewModel {

    // MARK: - Injected properties

    @Injected private var factory: UserProfileViewStateFactory

    private unowned let view: UserProfileViewProtocol
    private let router: StrongRouter<UserProfileRoute>

    private var bag = CancelBag()

    init(
        router: StrongRouter<UserProfileRoute>,
        view: UserProfileViewProtocol
    ) {
        self.router = router
        self.view = view

        bind()
    }

    deinit {
        print(" ☠️☠️☠️ DEINIT: \(String(describing: self))")
    }

    func set(image: UIImage) {
        view.apply(factory.make(with: .image(image)))
        UserDefaults.standard.saveNewSource(.image(image))
        view.hidePopUp()
    }
}

private extension UserProfileViewModel {
    func bind() {
        view.sourceConfigPublisher
            .compactMap { [weak self] in
                self?.factory.make(with: $0)
            }
            .sink { [weak self] in
                self?.view.apply($0)
            }
            .store(in: &bag)

        view.viewDidLoadPublisher
            .compactMap { [weak self] in
                self?.factory.make(with: UserDefaults.standard.currentSource)
            }
            .sink { [weak self] in
                self?.bindOnLoad()
                self?.view.apply($0)
            }
            .store(in: &bag)
    }

    func bindOnLoad() {
        view.cameraTappedPublisher
            .onMain()
            .sink { [unowned self] in
                router.trigger(.camera)
            }
            .store(in: &bag)

        view.saveTappedPublisher
            .sink { [unowned self] in
                UserDefaults.standard.saveNewSource($0)
                view.hidePopUp()
            }
            .store(in: &bag)
    }
}

extension AvatarSource {
    init?(with dic: [String: Any]) {
        if dic["image"] != nil {
            if let data = dic["image"] as? Data, let image = UIImage(data: data) {
                self = .image(image)
            } else {
                self = .image(.placeholder)
            }
        }
        if let flag = dic["gradient_enabled"] as? Bool {
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
            if let data = uIImage.pngData() {
                dic["image"] = data
            }
        }

        if var values = value(forKey: #function) as? [[String: Any]] {
            values.append(dic)
            setValue(dic, forKey: #function)
        }
    }

    var currentSource: AvatarSource? {
        get {
            if var value = value(forKey: #function) as? [String: Any] {
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
                if let data = uIImage.pngData() {
                    dic["image"] = data
                }
            case .none:
                break
            }
            setValue(dic, forKey: #function)
        }
    }

    var previousAvatarSources: [AvatarSource] {
        if var values = value(forKey: #function) as? [[String: Any]] {
            return values.compactMap { AvatarSource(with: $0) }
        }

        return []
    }
}
