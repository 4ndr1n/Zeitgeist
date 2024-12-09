//
//  ContentView.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 19.01.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var task: String = ""
    @State var showTasks: Bool = false
    
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    
    @State var overtime = true
    @State var doing = false
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.todo, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView{
            
            VStack(spacing:0){
                
                VStack(spacing:0){
                    if (overtime){
                        Text("\(formattedElapsedTime)")
                            .frame(maxWidth: .infinity)
                            .frame(height: 20)
                            .background(Color.green)
                    }else{
                        Text("\(formattedElapsedTime)")
                            .frame(maxWidth: .infinity)
                            .frame(height: 20)
                            .background(Color.red)
                    }
                    
                    
                        
                    Spacer()
                    if let currentItem = getCurrentTodoItem() {
                                         Text("\(currentItem.todo! )").font(.title)
                                     }
                    else
                    {
                        Text("Nothing to do").font(.title)
                    }
                    
                    Spacer()
                }
                
                VStack(spacing:0){
                    Button(action: {completed()}){
                        Text("Done")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height:80)
                            .background(Color.green)
                            .brightness(-0.2)
                    }
                        .contentShape(Rectangle())
                    
                    if (doing){
                        Button(action: {stopTimer()}){
                        Text("Pause")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height:80)
                            .background(Color.yellow)
                        }.contentShape(Rectangle())

                    }else{
                        Button(action: {startTimer()}){
                        Text("Continue")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height:80)
                            .background(Color.yellow)
                            
                        }.contentShape(Rectangle())
                    }
                    
                    Button(action: {switchTask()}){
                        Text("Switch Task")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height:80)
                            .background(Color.purple)
                            .brightness(-0.1)
                    }
                        .contentShape(Rectangle())
                    
                    Button(action: {emergencyTask()}){
                        Text("Emergency Task")
                            .foregroundColor(.black)
                            .accentColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height:80)
                            .background(Color.red)
                    }
                        .contentShape(Rectangle())
                }//Buttons VStack
            } //Screen VStack
            .toolbar{
                ToolbarItem{
                    NavigationLink(destination: editView()){
                        Label("Edit",systemImage: "gear")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    NavigationLink(destination: addView()){
                        Label("add",systemImage: "plus")
                    }
                }
            }
        }//Nav-view
        .sheet(isPresented: $showTasks) {
            TaskSheetView()
        }
    } //view
    
    private func switchTask(){
        showTasks.toggle()
        guard let currentItem = getCurrentItem() else { return }
        elapsedTime = currentItem.completionTime
    }
    
    private var formattedElapsedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func startTimer() {
        // Invalidate any existing timer
        timer?.invalidate()
        guard let currentItem = getCurrentItem() else { return }
        elapsedTime = currentItem.completionTime
        

        // Start a new timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
        doing.toggle()
    }
    
    private func stopTimer() {
        // Stop the timer
        timer?.invalidate()

        // Save the completion time to Core Data
        guard let currentItem = getCurrentItem() else { return }
        let elapsedTimeInSeconds = Double(elapsedTime)
        currentItem.completionTime = elapsedTimeInSeconds

        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
        doing.toggle()
    }

    private func getCurrentItem() -> Item? {
        return items.first(where: { $0.current })
    }

    private func emergencyTask(){
        let currentDate = Date()
        let plusOne = currentDate.addingTimeInterval(3600)
        let newItem = Item(context: viewContext)
        
        newItem.todo = "emergency Task"
        newItem.dueDate = plusOne
        newItem.date = Date()
        newItem.project = "emergency Task"
        newItem.isComplete = false
        
        let currentItem = items.first(where: { $0.current == true })
        currentItem?.current = false
        newItem.current = true
        
        do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        startTimer()
    }
    
    private func completed(){
        stopTimer()
        let currentItem = items.first(where: { $0.current == true })
        currentItem?.current = false
        currentItem?.isComplete = true
        
        do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
        elapsedTime = 0
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
    
    private func getCurrentTodoItem() -> Item? {
        if let currentItem = items.first(where: { $0.current == true }) {
            if currentItem.todo == "" {
                // If current item is empty, find the first item due today
                if let firstDueToday = items.first(where: { $0.date == Date() }) {
                    // Set its current flag to true
                    firstDueToday.current = true
                    do {
                        try viewContext.save() // Save changes to Core Data
                    } catch {
                        print("Error saving context: \(error)")
                    }
                    return firstDueToday
                }
            }
            return currentItem
        } else {
            // If no current item exists, find the first item due today and set its current flag to true
            if let firstDueToday = items.first(where: { $0.date == Date() }) {
                firstDueToday.current = true
                do {
                    try viewContext.save() // Save changes to Core Data
                } catch {
                    print("Error saving context: \(error)")
                }
                print("todo:\(firstDueToday.todo!)")
                return firstDueToday
            }
        }
        return nil
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}//View


struct TaskSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: true)],
        predicate: NSPredicate(format: "isComplete == false"),animation: .default)
    private var items: FetchedResults<Item>
    
    
    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.todo ?? "")
                    .onTapGesture {
                        let currentItem = items.first(where: { $0.current == true })
                        // Set the current item's property to false
                        currentItem?.current = false
                        // Set the tapped item's property to true
                        item.current = true
                        // Save changes to Core Data
                        do {
                            try item.managedObjectContext?.save()
                        } catch {
                            print("Error saving context: \(error)")
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .contentShape(Rectangle())
            } //Foreach
        }
    }
    
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
