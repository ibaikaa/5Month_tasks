//
//  DrinkCollectionViewCell.swift
//  cocktailsApp
//
//  Created by ibaikaa on 19/2/23.
//

import UIKit
import SnapKit
import Kingfisher

class DrinkCollectionViewCell: UICollectionViewCell {
    static let reuseID = String(describing: DrinkCollectionViewCell.self)
    
    private lazy var drinkImageView: UIImageView = {
        let imageView =  UIImageView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 100,
                height: 100
            )
        )
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var drinkNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buyDrinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainOrange
        button.titleLabel?.font = UIFont(
            name: "Avenir Next Bold",
            size: 18
        )
        button.setTitle("Buy now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        // Shadow configuration
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false
        
        button.addTarget(
            self,
            action: #selector(addToCart),
            for: .touchUpInside
        )
        
        return button
    }()
    
    @objc
    func addToCart() {
        print("add to cart. buy")
    }
   
    private func updateUI () {
        addSubview(drinkImageView)
        drinkImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(drinkImageView.frame.size.width)
            make.height.equalTo(drinkImageView.frame.size.height)
        }
        
        self.contentView.addSubview(drinkNameLabel)
        drinkNameLabel.snp.makeConstraints { make in
            make.top.equalTo(drinkImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        self.contentView.addSubview(buyDrinkButton)
        buyDrinkButton.snp.makeConstraints { make in
            make.top.equalTo(drinkNameLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    public func configure(with model: Drink) {
        guard let url = URL(string: model.drinkImageURLPath) else { return }
        drinkImageView.kf.setImage(with: url)
        drinkNameLabel.text = model.drinkName
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
}
