//
//  archiveView.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 22.01.2024.
//

import SwiftUI

struct archiveView: View {
    var body: some View {
        List{
            NavigationLink(destination: TimeView()){
                Label("Time",systemImage:"timer")
            }
            
            NavigationLink(destination: ProjectArchive()){
                Label("Projects",systemImage:"list.bullet")
            }
            
            NavigationLink(destination: TodoArchive()){
                Label("completed Todos",systemImage:"tray.full")
            }
            
        }
    }//body
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        archiveView()
    }
}
