import UIKit

class RestaurantViewController: UIViewController {
    let interactor: RestaurantInteractor
    let tableDirector = RestaurantTableDirector()
    
    lazy var contentView: RestaurantView = RestaurantView()

    init(interactor: RestaurantInteractor = RestaurantInteractor()) {
        
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func configureDashboard() {
        contentView.dashboardView.segmentedControl.addTarget(
            self,
            action: #selector(segmentedControlValueChanged(sender:)),
            for: .valueChanged
        )
        
        contentView.dashboardView.purgeButton.addTarget(self, action: #selector(purgeButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func purgeButtonPressed() {
        tableDirector.imageProvider.purge()
    }
    
    @objc
    private func segmentedControlValueChanged(sender: UISegmentedControl) {
        // A little bit of logic in VC :(
        switch sender.selectedSegmentIndex {
        case 0:
            tableDirector.setImageProvider(SDWeb())
        case 1:
            tableDirector.setImageProvider(KingFisher())
        case 2:
            tableDirector.setImageProvider(Nukie())
        default:
            return
        }
    }
}


extension RestaurantViewController {
    func presentRestaurants(_ restaurants: [Restaurant]) {
        tableDirector.setRestaurants(restaurants)
        contentView.tableView.reloadData()
    }
    
    func presentRequestFailure(with message: String) {
        let alert = UIAlertController(title: "Data request failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { _ in
            self.interactor.fetchRestaurants()
        }))
        alert.addAction(UIAlertAction(title: "Nevermind", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
