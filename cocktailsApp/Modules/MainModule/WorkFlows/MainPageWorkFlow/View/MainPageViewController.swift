//
//  MainPageViewController.swift
//  cocktailsApp
//
//  Created by ibaikaa on 19/2/23.
//

import UIKit
import SnapKit

class MainPageViewController: UIViewController {
    private var viewModel: MainViewModelType = MainViewModel()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    private func updateUI () {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    private var drinks = [Drink]() {
        didSet {
            tableView.reloadData()
        } willSet {
            print("new: \(newValue.count)")
        }
    }
    
    private func getDrinksForLetter(_ letter: String) {
        Task {
            drinks = try await viewModel.getDrinksForLetter(letter).drinks ?? []
        }
    }
    override func loadView() {
        super.loadView()
        updateUI()
        getDrinksForLetter("a")
    }
}

extension MainPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = drinks[indexPath.row].drinkName
        return cell
    }
}

extension MainPageViewController: UITableViewDelegate {
    
}
