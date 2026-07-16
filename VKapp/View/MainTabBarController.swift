import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        // Основной экран с постами (обёрнутый в UINavigationController)
        let feedVC = FeedViewController()
        let feedNavController = UINavigationController(rootViewController: feedVC)
        feedNavController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "house"), tag: 0)
        
        // Экран с сохранёнными постами (обёрнутый в UINavigationController)
        let savedPostsVC = SavedPostsViewController()
        let savedNavController = UINavigationController(rootViewController: savedPostsVC)
        savedNavController.tabBarItem = UITabBarItem(title: "Сохранённые", image: UIImage(systemName: "bookmark"), tag: 1)
        
        viewControllers = [feedNavController, savedNavController]
    }
}
