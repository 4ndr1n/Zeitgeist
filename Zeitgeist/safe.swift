//
//  editView.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 22.01.2024.
//
/*
import SwiftUI

struct TodoItem: Identifiable {
    var id = UUID()
    var text: String
}

struct editView: View{
    @State private var selectedDate = Date()
    
    @State private var weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    @State private var todoItems = [
        TodoItem(text: "Task 1"),
        TodoItem(text: "Task 2"),
        TodoItem(text: "Task 3"),
    ]
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.todo, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
      
    var body: some View{
        HStack {
            Text("as")
        }
        .toolbar{
            ToolbarItem{
                NavigationLink(destination: archiveView()){
                    Label("archive",systemImage:"tray.full")
                }
            }
            ToolbarItem{
                NavigationLink(destination: addView()){
                    Label("add",systemImage:"plus")
                }
            }
        }
        
    }//body
}//view

#Preview {
    editView()
}

*/
