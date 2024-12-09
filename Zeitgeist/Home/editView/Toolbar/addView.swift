//
//  addView.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 22.01.2024.
//

import SwiftUI

struct addView: View{
    @State var showAlert: Bool = false
    
    @State var todo: String = ""
    @State var date = Date()
    @State var dueDate = Date()
    @State var completionTime: Double = 0
    @State var isUrgent: Bool = false
    @State var number: Double = 0
    @State private var project: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.todo, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View{
        Form{
            TextField("I need to do...",text: $todo)
            HStack{
                Text("It'll take me(h)")
                TextField("It'll take me...h",value: $completionTime,formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
            
            HStack{
                Text("I'll do it on ")
                Spacer()
                DatePicker("I'll do it on...",selection: $date)
                        .labelsHidden()
            }
            HStack{
                Text("due date")
                Spacer()
                DatePicker("I'll do it on...",selection: $dueDate)
                        .labelsHidden()
            }
            
            NavigationLink(destination: projectView(project: $project)){
                Text("Project \(project)")
            }
            Button("add"){
                if (todo == ""){
                    showAlert = true
                }else{
                    addItem()
                }
                
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Empty Todo"), message: Text("Please enter a todo item."), dismissButton: .default(Text("OK")))
        }
    }//body


    
    private func addItem() {
        
        withAnimation {
        
            let newItem = Item(context: viewContext)
            newItem.completionTime = completionTime
            newItem.current = false
            newItem.date = date
            newItem.dueDate = dueDate
            newItem.isComplete = false
            newItem.todo = todo
            newItem.project = project
            

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            completionTime = 0
            todo = ""
        }
    }

}

#Preview {
    addView()
}
