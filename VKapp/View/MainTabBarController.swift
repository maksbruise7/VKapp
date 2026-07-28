import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        // Основной экран с постами
        let feedVC = FeedViewController()
        let feedNavController = UINavigationController(rootViewController: feedVC)
        feedNavController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "house"), tag: 0)
        
        // Экран с сохранёнными постами
        let savedPostsVC = SavedPostsViewController()
        let savedNavController = UINavigationController(rootViewController: savedPostsVC)
        savedNavController.tabBarItem = UITabBarItem(title: "Сохранённые", image: UIImage(systemName: "bookmark"), tag: 1)
        
        // НОВЫЙ ЭКРАН: Карта
        let mapVC = MapViewController()
        let mapNavController = UINavigationController(rootViewController: mapVC)
        mapNavController.tabBarItem = UITabBarItem(title: "Карта", image: UIImage(systemName: "map"), tag: 2)
        
        viewControllers = [feedNavController, savedNavController, mapNavController]
    }
}
