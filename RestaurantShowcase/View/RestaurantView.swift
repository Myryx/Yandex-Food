import Foundation
import UIKit
import SnapKit

class RestaurantView: UIView {
    
    lazy var refreshControl = UIRefreshControl()
    
    lazy var dashboardView = DashboardView()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        tableView.allowsSelection = true
        tableView.dragInteractionEnabled = true
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        return tableView
    }()
    
    override init(frame _: CGRect) {
        super.init(frame: CGRect.zero)
        addSubviews()
        makeConstraints()
        backgroundColor = .white
        tableView.register(RestaurantCell.self, forCellReuseIdentifier: "\(RestaurantCell.self)")
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        tableView.addSubview(refreshControl)
        addSubview(dashboardView)
        addSubview(tableView)
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(dashboardView.snp.bottom)
        }
        
        dashboardView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
    }
}
