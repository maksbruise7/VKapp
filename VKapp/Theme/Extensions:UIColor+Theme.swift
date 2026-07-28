import UIKit

extension UIColor {
    
    // MARK: - Основные цвета приложения
    
    /// Основной цвет фона (адаптивный)
    static var appBackground: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.0) // #121212
            default:
                return UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0) // #F2F2F7
            }
        }
    }
    
    /// Цвет для карточек/ячеек (адаптивный)
    static var appCardBackground: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.15, green: 0.15, blue: 0.16, alpha: 1.0) // #262628
            default:
                return UIColor.white
            }
        }
    }
    
    /// Основной цвет текста (адаптивный)
    static var appTextPrimary: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.0) // #F5F5F8
            default:
                return UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.0) // #121212
            }
        }
    }
    
    /// Вторичный цвет текста (адаптивный)
    static var appTextSecondary: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.62, green: 0.62, blue: 0.64, alpha: 1.0) // #9E9EA0
            default:
                return UIColor(red: 0.42, green: 0.42, blue: 0.44, alpha: 1.0) // #6C6C70
            }
        }
    }
    
    /// Цвет для разделителей (адаптивный)
    static var appSeparator: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.22, green: 0.22, blue: 0.24, alpha: 1.0) // #38383A
            default:
                return UIColor(red: 0.88, green: 0.88, blue: 0.89, alpha: 1.0) // #E1E1E6
            }
        }
    }
    
    // MARK: - Акцентные цвета (фиксированные)
    
    /// Синий цвет (акцент)
    static var appBlue: UIColor {
        return UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0) // #007AFF
    }
    
    /// Зеленый цвет (акцент)
    static var appGreen: UIColor {
        return UIColor(red: 0.0, green: 0.78, blue: 0.33, alpha: 1.0) // #00C84E
    }
    
    /// Красный цвет (акцент)
    static var appRed: UIColor {
        return UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0) // #FF3B30
    }
    
    /// Оранжевый цвет (акцент)
    static var appOrange: UIColor {
        return UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0) // #FF9500
    }
    
    /// Фиолетовый цвет (акцент)
    static var appPurple: UIColor {
        return UIColor(red: 0.69, green: 0.32, blue: 0.87, alpha: 1.0) // #AF52DE
    }
    
    // MARK: - Цвета для постов
    
    /// Цвет для аватара/автора (адаптивный)
    static var appAuthorColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.85, green: 0.85, blue: 0.88, alpha: 1.0)
            default:
                return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
        }
    }
    
    /// Цвет для даты поста (адаптивный)
    static var appDateColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.62, green: 0.62, blue: 0.64, alpha: 1.0)
            default:
                return UIColor(red: 0.42, green: 0.42, blue: 0.44, alpha: 1.0)
            }
        }
    }
    
    /// Цвет для текста поста (адаптивный)
    static var appPostText: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.92, green: 0.92, blue: 0.94, alpha: 1.0)
            default:
                return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
        }
    }
    
    /// Цвет для лайков (адаптивный)
    static var appLikesColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 1.0, green: 0.42, blue: 0.42, alpha: 1.0)
            default:
                return UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
            }
        }
    }
    
    /// Цвет для просмотров (адаптивный)
    static var appViewsColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.62, green: 0.62, blue: 0.64, alpha: 1.0)
            default:
                return UIColor(red: 0.42, green: 0.42, blue: 0.44, alpha: 1.0)
            }
        }
    }
    
    // MARK: - Цвета для карты
    
    /// Цвет фона карты (адаптивный)
    static var appMapBackground: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.05, green: 0.05, blue: 0.06, alpha: 1.0)
            default:
                return UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
            }
        }
    }
    
    /// Цвет информации на карте (адаптивный)
    static var appMapInfoBackground: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 0.95)
            default:
                return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95)
            }
        }
    }
    
    // MARK: - Цвета для TabBar
    
    /// Цвет TabBar (адаптивный)
    static var appTabBarBackground: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1.0)
            default:
                return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
            }
        }
    }
    
    // MARK: - Цвета для NavigationBar
    
    /// Цвет NavigationBar (адаптивный)
    static var appNavBarBackground: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1.0)
            default:
                return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
            }
        }
    }
}
