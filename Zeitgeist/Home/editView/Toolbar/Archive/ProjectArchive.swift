//
//  ProjectArchive.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 12.04.2024.
//

import SwiftUI

struct ProjectArchive: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.name, ascending: true)],
        animation: .default)
    private var projects: FetchedResults<Project>
    var body: some View {
        List{
            ForEach(projects) {proj in
                Text("\(proj.name ?? "no projects")")
                    .foregroundColor(.primary)
            }
            .onDelete(perform: deleteItems)
            NavigationLink(destination: addProject()){
                Text("new")
            }
        }//Grid
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for offset in offsets {
                viewContext.delete(projects[offset])
            }

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
    ProjectArchive()
}
