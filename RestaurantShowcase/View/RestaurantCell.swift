import Foundation
import UIKit
import SnapKit

protocol RestaurantCellConfigurable {
    var title: String { get }
    var description: String? { get }
}

class RestaurantCell: UITableViewCell {
    fileprivate let thumbnailInset: CGFloat = 12
    fileprivate let thumbnailSize = CGSize(width: 100, height: 75)
    fileprivate let titleInset: CGFloat = 12
    fileprivate let descriptionTopOffset: CGFloat = 4
    fileprivate let descriptionBottomOffset: CGFloat = 12
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    private func makeConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(thumbnailInset)
            make.centerY.equalToSuperview()
            make.size.equalTo(thumbnailSize)
            make.top.bottom.equalToSuperview().inset(thumbnailInset)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(thumbnailImageView.snp.right).offset(titleInset)
            make.right.equalToSuperview().inset(titleInset)
            make.top.equalToSuperview().offset(titleInset)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(descriptionTopOffset)
            make.bottom.equalToSuperview().inset(descriptionBottomOffset)
        }
    }
    
    func configure(with viewModel: RestaurantCellConfigurable) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
}
