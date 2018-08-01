//
//  Created by Daniel Esteban Cardona Rojas on 11/8/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import UIKit
import RxSwift

class MyModelListViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    private let refreshControl : UIRefreshControl = UIRefreshControl()
    
    var presenter : MyModelListPresenter?
    var models : [MyModelViewModel] = []
    private lazy var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapNavBar))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = self.refreshControl
        let nib = UINib(nibName: "LightShowTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LightShowTableViewCell")
        refreshControl.addTarget(self, action: #selector(refreshLightShowItems(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching most recent lightshows...")
        let settingsItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(tapNavBar(sender:)))
        self.navigationItem.setRightBarButton(settingsItem, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.attachView(view: self)
        presenter?.presentLatest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refreshLightShowItems(_ sender: Any) {
        self.presenter?.onListRefresh()
        refreshControl.endRefreshing()
    }
}


//MARK: LightShowListViewProtocol
extension MyModelListViewController : MyModelListViewInterface {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func display(lightShows: [MyModelViewModel]) {
        self.models = lightShows
        self.tableView.reloadData()
    }
    
    func showLoading() {
    }
    
    func hideLoading() {
        tableView.refreshControl?.endRefreshing()
    }
    
    //MARK: IBActions
    @objc func tapNavBar(sender: Any?){
        presenter?.onNavigationBarTapped()
    }
}

//MARK: TableViewDataSource
extension MyModelListViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LightShowTableViewCell")! as! MyModelTableViewCell
        let viewModel = models[indexPath.row]
        cell.render(viewModel)
        return cell
    }
    
}

// MARK: TableViewDeletegate
extension MyModelListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lightShowVM : MyModelViewModel = models[indexPath.row]
        presenter?.presentDetail(lightShowUUID: lightShowVM.uuid)
    }
}


