import Foundation
import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet { saveTasks() } // Автоматично запазване при всяка промяна
    }
    
    private let tasksKey = "saved_tasks"
    
    init() {
        loadTasks()
    }
    
    func addTask(title: String, date: Date, priority: Priority) {
        let newTask = Task(title: title, dueDate: date, priority: priority)
        tasks.append(newTask)
    }
    
    func toggleCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func updateTask(task: Task, newTitle: String, newDescription: String, newDate: Date, newPriority: Priority) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].title = newTitle
            tasks[index].taskDescription = newDescription
            tasks[index].dueDate = newDate
            tasks[index].priority = newPriority
        }
    }
    
    func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    private func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: tasksKey)
        }
    }
    
    private func loadTasks() {
        if let savedData = UserDefaults.standard.data(forKey: tasksKey),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedData) {
            self.tasks = decodedTasks
        }
    }
}
