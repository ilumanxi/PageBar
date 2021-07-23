//
//  ContentView.swift
//  ContentView
//
//  Created by 风起兮 on 2021/7/22.
//

import SwiftUI

extension Color {
    
    static var random: Color {
        Color(.sRGBLinear, red: Double.random(in: 0...1.0), green: Double.random(in: 0...1.0), blue: Double.random(in: 0...1.0), opacity: 1.0)
    }
}

struct Page: View, Identifiable {
    let id: UUID
    let model: Model
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
    
    var pageBar: some View {
        PageBar(currentIndex: $currentPage, items: items)
    }
    
    var pageViewController: some View {
        PageViewController(pages: pages, currentPage: $currentPage)
    }
    
    var body: some View {
        pageViewController
            .overlay(pageBar, alignment: .top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store.share)
    }
}
