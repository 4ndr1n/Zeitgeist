//
//  itemView.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 24.01.2024.
//

import SwiftUI

import Foundation

struct itemView: View {
    @State var todo_: String
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.todo, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var isEditing = false
    @State private var editedTodo: String = ""
    @State private var editedDoDate = Date()
    @State private var editedDueDate = Date()
    @State private var editedProject: String = ""
    @State private var completionTime: Double = 0
    
    var body: some View {
        if let item = items.first(where: { $0.todo == todo_ }) {

             List {
                 TextField("Todo", text: $editedTodo)
                     .disabled(!isEditing)
                     .foregroundColor(!isEditing ? .gray : .primary)
                 HStack{
                     Text("Completion time")
                     TextField("Completion time", value: $completionTime,formatter: NumberFormatter())
                     .disabled(!isEditing)
                     .keyboardType(.decimalPad)
                     .foregroundColor(!isEditing ? .gray : .primary)
                 }
                 DatePicker("Do Date", selection: $editedDoDate)
                     .disabled(!isEditing)
                 DatePicker("Due Date", selection: $editedDueDate)
                     .disabled(!isEditing)
                 NavigationLink(destination: projectView(project:   $editedProject)){
                 Text("Project \(editedProject)")
             
                }.disabled(!isEditing)
             } //List
             .onAppear {
                 // Set initial values when the view appears
                 if (!isEditing){
                     editedTodo = item.todo ?? ""
                     editedDoDate = item.date ?? Date()
                     editedDueDate = item.dueDate ?? Date()
                     editedProject = item.project ?? ""
                     completionTime = item.completionTime
                 }
             }
             .toolbar{
                 ToolbarItem(placement: .navigationBarTrailing) {
                     Button(action: {
                         isEditing.toggle()

                         if (!isEditing){
                             item.todo! = editedTodo
                             item.date! = editedDoDate
                             item.dueDate! = editedDueDate
                             item.project! = editedProject
                             
                         }

                         todo_ = editedTodo
                         do {
                             try viewContext.save()
                         } catch {
                             print("Error saving Context: \(error)")
                         }

                     }) {
                         Text(isEditing ? "Done" : "Edit")
                    }
                 }
             }
         } else {
             Text("No item found with todo: \(todo_)")
             }

        }//Body
    /*
         private let itemFormatter: DateFormatter = {
             let formatter = DateFormatter()
             formatter.dateStyle = .short
             formatter.timeStyle = .short
             return formatter
         }()
*/
}

#Preview {
    itemView(todo_:"bla").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
