import Foundation

extension Collection where Index == Int {
    
    /// For safe access to array elements by index
    ///
    /// - Parameter index: array index
    /// - Returns: array value
    func element(at index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
