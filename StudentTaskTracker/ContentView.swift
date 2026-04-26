import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TaskViewModel()
    @State private var newTaskTitle: String = ""
    @State private var dueDate: Date = Date()
    @State private var filterSelection = 0 // 0: All, 1: Pending, 2: Completed

    // Логика за филтриране на списъка
    var filteredTasks: [Task] {
        switch filterSelection {
        case 1: return viewModel.tasks.filter { !$0.isCompleted }
        case 2: return viewModel.tasks.filter { $0.isCompleted }
        default: return viewModel.tasks
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Секция за добавяне
                VStack {
                    TextField("New task name...", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        DatePicker("Due Date:", selection: $dueDate, displayedComponents: .date)
                            .labelsHidden()
                        Spacer()
                        Button("Add Task") {
                            if !newTaskTitle.isEmpty {
                                viewModel.addTask(title: newTaskTitle, date: dueDate)
                                newTaskTitle = ""
                                dueDate = Date()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
                
                // Филтър (Picker) - показва професионално ниво на работа с UI
                Picker("Filter", selection: $filterSelection) {
                    Text("All").tag(0)
                    Text("Pending").tag(1)
                    Text("Done").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Списък
                List {
                    ForEach(filteredTasks) { task in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .strikethrough(task.isCompleted)
                                    .fontWeight(.medium)
                                
                                Text(task.dueDate, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleCompletion(task: task)
                                }
                        }
                    }
                    .onDelete(perform: viewModel.deleteTasks) // Активира триенето чрез плъзгане
                }
            }
            .navigationTitle("My Tasks")
            .toolbar {
                EditButton() // Добавя бутон "Edit", който показва опциите за триене!
            }
        }
    }
}

