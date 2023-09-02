import SnapKit
import UIKit

final class CollectionViewCell: UICollectionViewCell {

    static let identifier = "cell"

    let timeLabel = UILabel()
    let temperatureImageView = UIImageView()
    let temperatureLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupBehavior()
        setupAppearance()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBehavior() {
        contentView.addSubviews(timeLabel, temperatureImageView, temperatureLabel)
    }

    private func setupAppearance() {

        contentView.backgroundColor = .clear

        temperatureImageView.contentMode = .scaleAspectFill

        timeLabel.customLabel(nameFont: "Poppins-Regular", sizeFont: 15)        

        temperatureLabel.customLabel(nameFont: "Poppins-Regular", sizeFont: 15)
    }

    private func setupConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(15)
            make.width.equalTo(27)
        }

        temperatureImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(46)
            make.left.right.equalToSuperview().inset(15)
            make.width.height.equalTo(43)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.height.equalTo(27)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
}
