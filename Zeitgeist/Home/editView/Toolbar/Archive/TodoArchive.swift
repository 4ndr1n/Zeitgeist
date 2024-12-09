//
//  TodoArchive.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 12.04.2024.
//

import SwiftUI

struct TodoArchive: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: true)],
        predicate: NSPredicate(format: "isComplete == true"),animation: .default)
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
                                  item.isComplete = false
                                  do {
                                      try viewContext.save()
                                  } catch {
                                      let nsError = error as NSError
                                      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                  }
                                  
                              }) {
                                  Label("undo", systemImage: "checkmark.circle")
                              }
                              .tint(.blue)
                          }
                    }
                    
                    
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Archive")
    }//View
    
    private var groupedTodos: [(Date, [Item])] {
      let groupedDictionary = Dictionary(grouping: items) { (item: Item) -> Date in
        guard let dateString = item.date else { return Date.distantPast }
        return dateFormatter.date(from: dateFormatter.string(from: dateString)) ?? Date.distantPast
      }
      return groupedDictionary.sorted { $0.key < $1.key }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    /*
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
            var itemsToDelete: [Item] = []
            
            for offset in offsets {
                 // Ensure that the offset is within the bounds of groupedTodos
                 guard offset < groupedTodos.count else { continue }
                 let (_, todosInDate) = groupedTodos[offset] // Get the tuple at the current index
                 // Add the todo items in the current group to the deletion array
                 itemsToDelete.append(contentsOf: todosInDate)
             }

             // Delete the items from the managed object context
             for item in itemsToDelete {
                 viewContext.delete(item)
             }
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
        }
    }
    */
    
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
    
}

#Preview {
    TodoArchive()
}
