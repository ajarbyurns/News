//
//  CategoriesViewController.swift
//  News
//
//  Created by bitocto_Barry on 07/02/23.
//

import UIKit

class SourcesViewController: UIViewController {
    
    var viewModel : SourcesViewModel
    var tableView : UITableView
    var loading : UIActivityIndicatorView
    
    init(_ viewModel: SourcesViewModel){
        self.viewModel = viewModel
        tableView = UITableView()
        loading = UIActivityIndicatorView(style: .large)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not in Storyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.viewModel.getSources()
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = lightBG
        
        self.navigationController?.navigationBar.topItem?.title = "\(viewModel.category.capitalized)"
        //self.navigationController?.navigationBar.backItem?.title = "Back"
        
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SourcesCell.self, forCellReuseIdentifier: cellId)
        
        loading.color = .black
        view.addSubview(loading)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.widthAnchor.constraint(equalToConstant: 40).isActive = true
        loading.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loading.hidesWhenStopped = false
        loading.startAnimating()
    }

}

extension SourcesViewController : UITableViewDelegate, UITableViewDataSource {
    
    var cellId : String {
        get { return "SourcesCell" }
    }
    
    var rowHeight : CGFloat {
        get { return 110 }
    }
    
    var spacing : CGFloat {
        get { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SourcesCell ?? SourcesCell()
        let source = viewModel.sources[indexPath.section]
        cell.nameLabel.text = source.name ?? ""
        cell.descLabel.text = source.description ?? ""
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vm = ArticlesViewModel(Repo(), viewModel.sources[indexPath.section].id ?? "")
        let vc = ArticlesViewController(vm)
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return spacing
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}

extension SourcesViewController : SourcesDelegate {
    
    func sourcesSet() {
        loading.isHidden = true
        tableView.reloadData()
    }
    
    func noMorePages() {
        print("All Pages Loaded")
    }
    
    func foundError(_ error: ApiError) {
        switch error {
        case .Connection:
            print("Connection Error")
        case .URL:
            print("URL Error")
        case .Json:
            print("JSON Error")
        }
    }
    
}

