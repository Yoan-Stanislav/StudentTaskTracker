import SwiftUI

struct EditTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskViewModel
    
    var task: Task
    
    @State private var editedTitle: String
    @State private var editedDescription: String
    @State private var editedDate: Date
    @State private var editedPriority: Priority
    
    init(viewModel: TaskViewModel, task: Task) {
        self.viewModel = viewModel
        self.task = task
        _editedTitle = State(initialValue: task.title)
        _editedDescription = State(initialValue: task.taskDescription)
        _editedDate = State(initialValue: task.dueDate)
        _editedPriority = State(initialValue: task.priority)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Information")) {
                TextField("Title", text: $editedTitle)
                TextEditor(text: $editedDescription)
                    .frame(height: 100)
            }
            
            Section(header: Text("Settings")) {
                DatePicker("Due Date", selection: $editedDate, displayedComponents: .date)
                Picker("Priority", selection: $editedPriority) {
                    ForEach(Priority.allCases, id: \.self) { p in
                        Text(p.rawValue).tag(p)
                    }
                }
            }
            
            Button("Save Changes") {
                viewModel.updateTask(task: task, newTitle: editedTitle, newDescription: editedDescription, newDate: editedDate, newPriority: editedPriority)
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Edit Task")
    }
}
