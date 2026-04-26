import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TaskViewModel()
    @State private var searchText = ""
    @State private var newTaskTitle: String = ""
    @State private var dueDate: Date = Date()
    @State private var selectedPriority: Priority = .medium
    @State private var filterSelection = 0

    var filteredTasks: [Task] {
        var result = viewModel.tasks
        if filterSelection == 1 { result = result.filter { !$0.isCompleted } }
        else if filterSelection == 2 { result = result.filter { $0.isCompleted } }
        
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        return result
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 10) {
                    TextField("Add new task...", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        DatePicker("", selection: $dueDate, displayedComponents: .date)
                            .labelsHidden()
                        
                        Picker("Priority", selection: $selectedPriority) {
                            ForEach(Priority.allCases, id: \.self) { p in
                                Text(p.rawValue).tag(p)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Button("Add") {
                            if !newTaskTitle.isEmpty {
                                viewModel.addTask(title: newTaskTitle, date: dueDate, priority: selectedPriority)
                                newTaskTitle = ""
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()

                Picker("", selection: $filterSelection) {
                    Text("All").tag(0)
                    Text("Pending").tag(1)
                    Text("Done").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    ForEach(filteredTasks) { task in
                        NavigationLink(destination: EditTaskView(viewModel: viewModel, task: task)) {
                            HStack {
                                Circle()
                                    .fill(task.priority.color)
                                    .frame(width: 10, height: 10)
                                
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .strikethrough(task.isCompleted)
                                    Text(task.dueDate, style: .date)
                                        .font(.caption).foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.toggleCompletion(task: task)
                                }) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isCompleted ? .green : .gray)
                                        .imageScale(.large)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteTasks)
                }
            }
            .navigationTitle("My Tasks")
            .searchable(text: $searchText, prompt: "Search...")
            .toolbar { EditButton() }
        }
    }
}
