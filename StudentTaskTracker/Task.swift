import Foundation
import SwiftUI

// Enum за приоритет 
enum Priority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
}

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var taskDescription: String = ""
    var dueDate: Date
    var isCompleted: Bool = false
    var priority: Priority = .medium // Ново поле
}
