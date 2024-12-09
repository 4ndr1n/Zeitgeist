//
//  editView.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 22.01.2024.
//

import SwiftUI
import CoreData

struct editView: View {
    @State private var timeline = true

    var body: some View {
        HStack(spacing: 0){
            Button("Timeline"){
                timeline = true
            }
            .foregroundColor(!timeline ? .gray : .primary)
            .buttonStyle(.bordered)
            Button("Project-view"){
                timeline = false
            }
            .buttonStyle(.bordered)
            .foregroundColor(timeline ? .gray : .primary)
            
        }
        if (timeline){
            timelineView()
        }else{
            ProjectScreen()
        }
        
        
    }
}

struct editView_Previews: PreviewProvider {
    static var previews: some View {
        editView()
    }
}
