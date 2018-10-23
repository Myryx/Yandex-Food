//
//  ViewController.swift
//  RestaurantShowcase
//
//  Created by Yanislav Kononov on 10/21/18.
//  Copyright © 2018 Yanislav. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
    let interactor: RestaurantInteractor
    let tableDirector = RestaurantTableDirector()
    
    lazy var contentView: RestaurantView = RestaurantView()

//    override func loadView() {
//        view = RestaurantView()
//    }
    
    override func loadView() {
        view = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchRestaurants()
        contentView.tableView.dataSource = tableDirector
        contentView.tableView.delegate = tableDirector
        contentView.tableView.prefetchDataSource = tableDirector
        
        configureDashboard()
    }
    
    init(interactor: RestaurantInteractor = RestaurantInteractor()) {
        
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentRestaurants(_ restaurants: [Restaurant]) {
        tableDirector.setRestaurants(restaurants)
        contentView.tableView.reloadData()
    }
    
    func configureDashboard() {
        contentView.dashboardView.segmentedControl.addTarget(
            self,
            action: #selector(segmentedControlValueChanged(sender:)),
            for: .valueChanged
        )
        
        contentView.dashboardView.purgeButton.addTarget(self, action: #selector(purgeButtonPressed), for: .touchUpInside)
    }
    
    @objc
    func purgeButtonPressed() {
        tableDirector.imageProvider.purge()
    }
    
    @objc
    func segmentedControlValueChanged(sender: UISegmentedControl) {
        // A little bit of logic in VC :(
        switch sender.selectedSegmentIndex {
        case 0:
            tableDirector.setProvider(SDWeb())
        case 1:
            tableDirector.setProvider(KingFisher())
        case 2:
            tableDirector.setProvider(Nukee())
        default:
            return
        }
        
        
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .default
//    }
}
