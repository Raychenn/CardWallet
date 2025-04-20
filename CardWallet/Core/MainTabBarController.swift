//
//  MainTabbarController.swift
//  CardWallet
//
//  Created by Boray Chen on 2025/4/20.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        // Create view controllers for each tab
        let transactionsVC = UIViewController()
        transactionsVC.title = "Transactions"
        let transactionsNav = UINavigationController(rootViewController: transactionsVC)
        transactionsNav.navigationBar.standardAppearance = appearance
        transactionsNav.navigationBar.scrollEdgeAppearance = appearance
        transactionsNav.tabBarItem = UITabBarItem(
            title: "Transactions",
            image: UIImage(systemName: "arrow.left.arrow.right"),
            selectedImage: UIImage(systemName: "arrow.left.arrow.right.fill")
        )
        
        let cardsVC = CardsViewController()
        let cardsNav = UINavigationController(rootViewController: cardsVC)
        cardsNav.navigationBar.standardAppearance = appearance
        cardsNav.navigationBar.scrollEdgeAppearance = appearance
        cardsNav.tabBarItem = UITabBarItem(
            title: "Cards",
            image: UIImage(systemName: "creditcard"),
            selectedImage: UIImage(systemName: "creditcard.fill")
        )
        
        let paymentsVC = UIViewController()
        paymentsVC.title = "Payments"
        let paymentsNav = UINavigationController(rootViewController: paymentsVC)
        paymentsNav.navigationBar.standardAppearance = appearance
        paymentsNav.navigationBar.scrollEdgeAppearance = appearance
        paymentsNav.tabBarItem = UITabBarItem(
            title: "Payments",
            image: UIImage(systemName: "dollarsign.circle"),
            selectedImage: UIImage(systemName: "dollarsign.circle.fill")
        )
        
        let statementsVC = UIViewController()
        statementsVC.title = "Statements"
        let statementsNav = UINavigationController(rootViewController: statementsVC)
        statementsNav.navigationBar.standardAppearance = appearance
        statementsNav.navigationBar.scrollEdgeAppearance = appearance
        statementsNav.tabBarItem = UITabBarItem(
            title: "Statements",
            image: UIImage(systemName: "doc.text"),
            selectedImage: UIImage(systemName: "doc.text.fill")
        )
        
        let moreVC = UIViewController()
        moreVC.title = "More"
        let moreNav = UINavigationController(rootViewController: moreVC)
        moreNav.navigationBar.standardAppearance = appearance
        moreNav.navigationBar.scrollEdgeAppearance = appearance
        moreNav.tabBarItem = UITabBarItem(
            title: "More",
            image: UIImage(systemName: "ellipsis"),
            selectedImage: UIImage(systemName: "ellipsis")
        )
        
        // Set up tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        // Set the view controllers and selected index
        viewControllers = [
            transactionsNav,
            cardsNav,
            paymentsNav,
            statementsNav,
            moreNav
        ]
        selectedIndex = 1 // Select Cards tab by default
    }

}
