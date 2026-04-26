import Foundation
import SwiftUI
import Combine
// ViewModel се грижи за логиката и връзката с Model
class TaskViewModel: ObservableObject {
    // @Published автоматично обновява интерфейса при промяна на данните
    @Published var tasks: [Task] = []
    
    func addTask(title: String, date: Date) {
        let newTask = Task(title: title, dueDate: date)
        tasks.append(newTask)
    }
    
    func toggleCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}
