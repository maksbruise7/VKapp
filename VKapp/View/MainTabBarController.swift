import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLocalization),
            name: Notification.Name("LanguageChanged"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupAppearance() {
        // Настройка TabBar
        tabBar.backgroundColor = .appTabBarBackground
        tabBar.tintColor = .appBlue
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .appTabBarBackground
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        // Настройка NavigationBar
        let navAppearance = UINavigationBarAppearance()
        navAppearance.backgroundColor = .appNavBarBackground
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.appTextPrimary]
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
    }
    
    private func setupTabs() {
        let feedVC = FeedViewController()
        let feedNav = UINavigationController(rootViewController: feedVC)
        feedNav.tabBarItem = UITabBarItem(
            title: "tab_feed".localized,
            image: UIImage(systemName: "house"),
            tag: 0
        )
        
        let savedVC = SavedPostsViewController()
        let savedNav = UINavigationController(rootViewController: savedVC)
        savedNav.tabBarItem = UITabBarItem(
            title: "tab_saved".localized,
            image: UIImage(systemName: "bookmark"),
            tag: 1
        )
        
        let mapVC = MapViewController()
        let mapNav = UINavigationController(rootViewController: mapVC)
        mapNav.tabBarItem = UITabBarItem(
            title: "tab_map".localized,
            image: UIImage(systemName: "map"),
            tag: 2
        )
        
        let langVC = LanguageSelectionViewController()
        let langNav = UINavigationController(rootViewController: langVC)
        langNav.tabBarItem = UITabBarItem(
            title: "language".localized,
            image: UIImage(systemName: "globe"),
            tag: 3
        )
        
        viewControllers = [feedNav, savedNav, mapNav, langNav]
    }
    
    @objc func updateLocalization() {
        if let items = tabBar.items {
            let titles = [
                "tab_feed".localized,
                "tab_saved".localized,
                "tab_map".localized,
                "language".localized
            ]
            for (index, item) in items.enumerated() {
                if index < titles.count {
                    item.title = titles[index]
                }
            }
        }
    }
}
