import Foundation
import UIKit

class DashboardView: UIView {
    let separatorHeight: CGFloat = 0.5
    
    lazy var purgeButton: UIButton = {
        let purgeButton = UIButton()
        purgeButton.setTitle("Purge", for: UIControl.State())
        purgeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        purgeButton.setTitleColor(.black, for: UIControl.State())
        return purgeButton
    }()
    
    lazy var separator = UIView()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.tintColor = .black
        return segmentedControl
    }()
    
    override init(frame _: CGRect) {
        super.init(frame: CGRect.zero)
        addSubviews()
        makeConstraints()
        backgroundColor = .white
        separator.backgroundColor = .lightGray
        configureSegmentedControl()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(segmentedControl)
        addSubview(separator)
        addSubview(purgeButton)
    }
    
    private func makeConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(80)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(separatorHeight)
        }
        purgeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
            make.left.equalTo(segmentedControl.snp.right).offset(12)
        }
    }
    private func configureSegmentedControl() {
        segmentedControl.insertSegment(
            withTitle: "SWWeb",
            at: 0,
            animated: true
        )
        
        segmentedControl.insertSegment(
            withTitle: "KingFisher",
            at: 1,
            animated: true
        )
        
        segmentedControl.insertSegment(
            withTitle: "Nuke",
            at: 2,
            animated: true
        )
        segmentedControl.selectedSegmentIndex = 0
    }
}
