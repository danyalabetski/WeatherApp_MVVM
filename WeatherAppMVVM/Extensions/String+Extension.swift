import Foundation

extension String {
    func hhDate() -> String? {
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let date = formatter.date(from: self) else { return nil }

        formatter.dateFormat = "HH"

        let str = formatter.string(from: date)

        return str
    }
}
