import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

// Расширение для форматирования чисел
extension Int {
    func localizedString(forKey key: String) -> String {
        return key.localized(with: self)
    }
}

// Удобная функция для локализации
func loc(_ key: String) -> String {
    return key.localized
}

func loc(_ key: String, _ arguments: CVarArg...) -> String {
    return String(format: key.localized, arguments: arguments)
}
