//
//  addProject.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 29.01.2024.
//

import SwiftUI

struct addProject: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var terminated: Bool = false
    @State var name:String = ""
    @State var start_Date:Date = Date()
    @State var end_Date:Date = Date()
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.name, ascending: true)],
        animation: .default)
    private var projects: FetchedResults<Project>
    
    var body: some View {
        List{
            TextField("Project name",text: $name)
            Button("add"){
                addItem()
                presentationMode.wrappedValue.dismiss()
            }

            
        }
    }//body
    
    private func addItem() {
        withAnimation {
        
            let newItem = Project(context: viewContext)
            newItem.name = name
            

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            name = ""
        }
    }
}

#Preview {
    addProject()
}
