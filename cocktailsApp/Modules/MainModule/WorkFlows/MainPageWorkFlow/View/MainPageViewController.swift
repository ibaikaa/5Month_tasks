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
  
    // For requesting to API to get next letter's drinks
    private var currentLetterUnicodeValue: UInt32 = 97
    private var currentLetter = "a"
  
    private var drinks = [Drink]() {
        didSet {
            filteredDrinks = drinks
        }
    }
    
    private func updateUIwithSearchResultsState(resultIsEmpty: Bool) {
        if filteredDrinks.isEmpty && !drinks.isEmpty {
            drinksCollectionView.isHidden = true
            noCocktailsFoundLabel.isHidden = false
        } else {
            drinksCollectionView.isHidden = false
            noCocktailsFoundLabel.isHidden = true
        }
    }
    
    private var filteredDrinks = [Drink]() {
        didSet {
            updateUIwithSearchResultsState(resultIsEmpty: filteredDrinks.isEmpty)
            drinksCollectionView.reloadData()
        }
    }
    
    // MARK: Call API methods ()
    private func getDrinksForLetter(_ letter: String) {
        Task {
            let drinksFromAPI = try await viewModel.getDrinksForLetter(letter).drinks ?? []
            drinks.append(contentsOf: drinksFromAPI)
        }
    }
    
    private func getDrinksForName(_ name: String) {
        Task {
            filteredDrinks = try await viewModel.getDrinksByName(name).drinks ?? []
        }
    }

    // MARK: Subviews creating
    private lazy var allDrinksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "All Cocktails"
        label.font = UIFont(name: "Avenir Next Bold", size: 26)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pageInfoSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover your special cocktail\n among all available below."
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir-Roman", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // UISearchBar for searching drink by name.
    private lazy var searchDrinkSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search drink by name"
        searchBar.searchTextField.font = UIFont(name: "Avenir Next", size: 17)
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .mainOrange
        searchBar.searchTextField.backgroundColor = .white
        searchBar.enablesReturnKeyAutomatically = false
        
        // Shadow configuration
        searchBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowRadius = 4
        searchBar.layer.masksToBounds = false
        
        return searchBar
    }()
        
    // Background view for UICollectionView creating
    private lazy var backgroundViewForCollection: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBeige
        view.clipsToBounds = true
        view.layer.cornerRadius = 28
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    // UICollectionView creating
    private lazy var drinksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
  
    // No Cocktails found Label creating. Appears in case if
    // there is no cocktail found with name that was input.
    private lazy var noCocktailsFoundLabel: UILabel = {
        let label =  UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: drinksCollectionView.bounds.size.width,
                height: 50
            )
        )
        label.text = "No cocktails found🤕\nPlease, try again."
        label.font = UIFont(name: "Avenir Next", size: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    // MARK: updateUI() method
    private func updateUI() {
        view.backgroundColor = .mainOrange
        
        view.addSubview(allDrinksTitleLabel)
        allDrinksTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(pageInfoSubtitleLabel)
        pageInfoSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(allDrinksTitleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(searchDrinkSearchBar)
        searchDrinkSearchBar.snp.makeConstraints { make in
            make.top.equalTo(pageInfoSubtitleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
        
        view.addSubview(backgroundViewForCollection)
        backgroundViewForCollection.snp.makeConstraints { make in
            make.top.equalTo(searchDrinkSearchBar.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }

        view.addSubview(drinksCollectionView)
        drinksCollectionView.snp.makeConstraints { make in
            make.top.equalTo(backgroundViewForCollection.snp.top)
            make.left.equalTo(backgroundViewForCollection.snp.left).offset(20)
            make.right.equalTo(backgroundViewForCollection.snp.right).offset(-20)
            make.bottom.equalTo(backgroundViewForCollection.snp.bottom)
        }
        
        view.addSubview(noCocktailsFoundLabel)
        noCocktailsFoundLabel.snp.makeConstraints { make in
            make.centerX.equalTo(drinksCollectionView.snp.centerX)
            make.centerY.equalTo(drinksCollectionView.snp.centerY)
        }
    }
    
    // MARK: Configuring methods ()
    private func configureSearchDrinkSearchBar() {
        searchDrinkSearchBar.delegate = self
    }
    
    private func configureDrinksCollectionView() {
        drinksCollectionView.register(
            DrinkCollectionViewCell.self,
            forCellWithReuseIdentifier: DrinkCollectionViewCell.reuseID
        )
        drinksCollectionView.delegate = self
        drinksCollectionView.dataSource = self
    }
    
    override func loadView() {
        super.loadView()
        updateUI()
        configureDrinksCollectionView()
        configureSearchDrinkSearchBar()
        getDrinksForLetter(currentLetter)
    }
}

extension MainPageViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int { filteredDrinks.count }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = drinksCollectionView.dequeueReusableCell(
            withReuseIdentifier: DrinkCollectionViewCell.reuseID,
            for: indexPath
        ) as? DrinkCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: filteredDrinks[indexPath.row])
        return cell
    }
}

extension MainPageViewController: UICollectionViewDelegateFlowLayout {
    private func moveToNextLetter(
        letter: inout String,
        value: inout UInt32
    ) {
        value += 1
        let scalar = UnicodeScalar(value)!
        letter = String(scalar)
    }
    
    private func fetchNextData () {
        moveToNextLetter(
            letter: &currentLetter,
            value: &currentLetterUnicodeValue
        )
        getDrinksForLetter(currentLetter)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check if the user has scrolled to the bottom of the view and it is not
        // searching cocktail process
        let scrollViewContentHeight = drinksCollectionView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - drinksCollectionView.bounds.size.height
        
        if scrollView.contentOffset.y > scrollOffsetThreshold,
            searchDrinkSearchBar.text!.isEmpty {
            fetchNextData()
        }
    }
}

extension MainPageViewController {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellCustomWidth = (collectionView.bounds.width - 20) / 2
        return CGSize(width: cellCustomWidth, height: cellCustomWidth + 40)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        // go to drink detailed vc
    }
}


extension MainPageViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        guard !searchText.isEmpty else { filteredDrinks = drinks; return }
        getDrinksForName(searchText)
    }
}
