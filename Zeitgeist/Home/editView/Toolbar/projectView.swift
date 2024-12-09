//
//  projectView.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 29.01.2024.
//

import SwiftUI

struct projectView: View {
    @Binding var project: String
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.name, ascending: true)],
        animation: .default)
    private var projects: FetchedResults<Project>
    
    @State var proName:String = ""
    
    var body: some View {
        List {
            ForEach(projects) {proj in
                Button("\(proj.name!)"){
                    project = proj.name!
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.black)
                }
            Button("no project"){
                project = ""
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.gray)
            NavigationLink(destination: addProject()){
                Text("new")
            }
            .foregroundColor(Color.blue)
            .brightness(-0.1)
        } //list end
    }//Body
    
}//View
/*
#Preview {
    @State var test: String = "test"
    projectView(project: "test")
}
*/
