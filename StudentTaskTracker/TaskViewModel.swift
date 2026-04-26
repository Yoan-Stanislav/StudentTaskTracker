import Foundation
import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [] {
        // Всеки път, когато масивът се промени, автоматично запазваме данните
        didSet {
            saveTasks()
        }
    }
    
    // Ключът, под който ще пазим данните в телефона
    private let tasksKey = "saved_tasks"
    
    init() {
        loadTasks() // Зареждаме задачите веднага щом приложението стартира
    }
    
    func addTask(title: String, date: Date) {
        let newTask = Task(title: title, dueDate: date)
        tasks.append(newTask)
    }
    
    func toggleCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    // Функция за изтриване на задачи
    func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    // Запазване в паметта (кодиране в JSON)
    private func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: tasksKey)
        }
    }
    
    // Зареждане от паметта (декодиране от JSON)
    private func loadTasks() {
        if let savedData = UserDefaults.standard.data(forKey: tasksKey),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedData) {
            self.tasks = decodedTasks
        }
    }
}
