//
//  ContentView.swift
//  ContentView
//
//  Created by 风起兮 on 2021/7/22.
//

import SwiftUI

struct Page: View, Identifiable {
    
    var id: UUID
    
    var model: Model
      
    var body: some View {
        ZStack {
            Color.random
            
            Text("\(model.title)")
                .foregroundColor(.primary)
                .font(.title)
           
        }
    }
}

struct ContentView: View {
    
    @EnvironmentObject var store: Store
    
    @State private var currentPage = 0
    
    var pages: [Page] {
        store.items.map {
            Page(id: $0.id, model: $0)
        }
    }
    
    var items: [PageBar.Item]{
        store.items.map {
            PageBar.Item(title: $0.title)
        }
    }
    
    var body: some View {
        PageController(currentPage: $currentPage, pages: pages, items: items)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store.share)
    }
}
