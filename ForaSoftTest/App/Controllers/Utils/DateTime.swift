import Foundation

// MARK: - Converts a date to the format returned by iTunes, and provides retrieve the date elements
extension Date {
    
    var year: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    var month: Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    
    var day: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    init?(string: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard
            let date = dateFormatter.date(from: string)
        else {
            return nil
        }
        self.init(timeInterval: 0, since: date)
    }
}
