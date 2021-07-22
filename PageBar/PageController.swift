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
            red:    Double.random(in: 0.5...1.0),
            green:  Double.random(in: 0.5...1.0),
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
        PageController(currentPage: .constant(0), pages: Store.share.items.map {Page(id: $0.id, model: $0)}, items: Store.share.items.map(\.title).map(PageBar.Item.init(title:)))
    }
}
