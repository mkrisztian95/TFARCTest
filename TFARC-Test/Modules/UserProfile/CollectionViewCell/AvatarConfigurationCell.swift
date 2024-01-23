import CustomizableAvatar
import UIKitPlus

class AvatarConfigurationCell: CollectionViewCell {

    private lazy var avatarView: Avatar = {
        let avatarView = Avatar(frame: .zero)
        contentView.addSubview(avatarView)
        avatarView.preparedForAutoLayout()

        NSLayoutConstraint.activate {
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor)
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            avatarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        }
        avatarView.setHidden(true, withDuration: .zero)
        return avatarView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        avatarView.setHidden(false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(_ configuration: Avatar.AvatarConfiguration) {
        avatarView.apply(configuration)
    }
}
