//
//  ContentView.swift
//  PageBar
//
//  Created by 风起兮 on 2021/7/21.
//

import SwiftUI

extension Color {
    
    static var random: Color {
        Color(
            red:    Double.random(in: 0.5...0.8),
            green:  Double.random(in: 0.5...0.6),
            blue:   Double.random(in: 0.5...1.0)
        )
            .opacity(Double.random(in: 0.5...1.0))
    }
}

struct PageController: View {
    
    @Binding var currentPage: Int
    
    var pages: [Page]
    
    var items: [PageBar.Item]
    
    
    var pageBar: some View {
        PageBar(currentIndex: $currentPage, items: items)
    }
    
    var pageView: some View {
        PageView(currentPage: $currentPage, pages: pages)
    }
    
    var body: some View {
        pageView
            .ignoresSafeArea(.all)
            .overlay(pageBar, alignment: .top)
            .onAppear{
                currentPage  = 0
            }
    }
        
}


struct PageController_Previews: PreviewProvider {
    static var previews: some View {
        PageController(currentPage: .constant(1), pages: [Page(id: Store.share.items.first!.id, model: Store.share.items.first!)], items: [PageBar.Item(title: Store.share.items.first!.title)])
    }
}
