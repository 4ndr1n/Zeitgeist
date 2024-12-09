//
//  timelineView.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 30.01.2024.
//

import SwiftUI

struct timelineView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: true)],
        predicate: NSPredicate(format: "isComplete == false"),animation: .default)
    private var items: FetchedResults<Item>
    var body: some View {
        List {
            ForEach(groupedTodos, id: \.0) { date, todosInDate in
                Section(header: Text(dateFormatter.string(from: date))) {
                    ForEach(todosInDate) { item in
                            NavigationLink(destination: itemView(todo_: item.todo ?? "Todo not found")){
                            Text("\(item.todo ?? "Todo not found")")
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                              Button(action: {
                                  // Add a day to the task
                                  addDay(to: item)
                              }) {
                                  Label("Add Day", systemImage: "calendar.badge.plus")
                              }
                              .tint(.blue)
                            
                            Button(action: {
                                becomePrimary(to: item)
                            }) {
                                Label("Move After Next", systemImage: "arrow.turn.up.forward.iphone")
                            }
                            .tint(.yellow)
                            
                            Button(action: {
                                isDone(to: item)
                            }) {
                                Label("Move After Next", systemImage: "checkmark.circle.fill")
                            }
                            .tint(.green)
                            
                                              }
                    }
                }
            } //Foreach
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            ToolbarItem {
                NavigationLink(destination: archiveView()){
                    Label("archive",systemImage:"tray.full")
                }
            }
            ToolbarItem {
                NavigationLink(destination: addView()){
                    Label("add",systemImage:"plus")
                }
            }
        }
    }//body
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private func addDay(to item: Item) {
        guard let dueDate = item.date else { return }
        if let newDueDate = Calendar.current.date(byAdding: .day, value: 1, to: dueDate) {
            item.date = newDueDate
            
            // Save the changes to Core Data
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        print("\(item.dueDate!)")
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private var groupedTodos: [(Date, [Item])] {
      let groupedDictionary = Dictionary(grouping: items) { (item: Item) -> Date in
        guard let dateString = item.date else { return Date.distantPast }
        return dateFormatter.date(from: dateFormatter.string(from: dateString)) ?? Date.distantPast
      }
      return groupedDictionary.sorted { $0.key < $1.key }
    }
    
    private func becomePrimary(to item: Item){
        let currentItem = items.first(where: { $0.current == true })
        currentItem?.current = false
        item.current = true
        
        do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
    }
    
    private func isDone(to item: Item){
        item.isComplete = true
        do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
    }
    
}//view

#Preview {
    timelineView()
}
