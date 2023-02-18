//
//  MainTabBarController.swift
//  drinksProject
//
//  Created by ibaikaa on 19/2/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    private func generateVC (
        from baseVC: UIViewController,
        image: UIImage?
    ) -> UIViewController {
        let itemVC = UINavigationController(rootViewController: baseVC)
        itemVC.tabBarItem.title = title
        itemVC.tabBarItem.image = image
        return itemVC
    }
    
    private let itemIcons: [UIImage] = [
        UIImage(systemName: "person.circle") ?? UIImage(),
        UIImage(systemName: "house.circle") ?? UIImage(),
        UIImage(systemName: "cart.circle") ?? UIImage(),
        UIImage(systemName: "folder.badge.plus.fill") ?? UIImage()
    ]
    
    private func generateItemIcon(from icon: UIImage) -> UIImage {
        icon.resizeImage(to: CGSize(width: 40, height: 40))
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                from: ProfileViewController(),
                image: generateItemIcon(from: itemIcons[0])
            ),
            generateVC(
                from: MainPageViewController(),
                image: generateItemIcon(from: itemIcons[1])
            ),
            generateVC(
                from: CartViewController(),
                image: generateItemIcon(
                    from: generateItemIcon(from: itemIcons[2])
                )
            ),
            generateVC(
                from: AddDrinkViewController(),
                image: generateItemIcon(from: itemIcons[3])
            )
        ]
        self.selectedIndex = 1
    }
    
    private func setTabBarAppearance() {
        // Colors configuring for UITabBar
        tabBar.backgroundColor = .mainBeige
        tabBar.tintColor = .mainOrange
        tabBar.unselectedItemTintColor = .tabBarItemLight
        tabBar.isTranslucent = true
        
        tabBar.clipsToBounds = true
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .mainBeige
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        tabBar.itemPositioning = .centered
    }
    
    override func loadView() {
        super.loadView()
        generateTabBar()
        setTabBarAppearance()
    }
    
}
