import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TaskViewModel()
    @State private var newTaskTitle: String = ""
    @State private var dueDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                // Поле за въвеждане на нова задача и избор на дата
                HStack {
                    TextField("New task...", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Календарче за избор на дата
                    DatePicker("", selection: $dueDate, displayedComponents: .date)
                        .labelsHidden()
                    
                    Button(action: {
                        if !newTaskTitle.isEmpty {
                            viewModel.addTask(title: newTaskTitle, date: dueDate)
                            newTaskTitle = ""
                            dueDate = Date() // Нулираме датата след добавяне
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
                .padding()
                
                // Списък със задачите
                List {
                    ForEach(viewModel.tasks) { task in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .strikethrough(task.isCompleted)
                                
                                // Показваме крайния срок с малък сив шрифт
                                Text(task.dueDate, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleCompletion(task: task)
                                }
                        }
                    }
                    .onDelete(perform: viewModel.deleteTasks) // Този ред добавя функцията за изтриване
                }
            }
            .navigationTitle("My tasks")
        }
    }
}
