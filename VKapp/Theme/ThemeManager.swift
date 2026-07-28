import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    
    private init() {}
    
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return UITraitCollection.current.userInterfaceStyle == .dark
        }
        return false
    }
    
    func applyTheme() {
        // Принудительно обновить все окна
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}
