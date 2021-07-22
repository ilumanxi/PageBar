//
//  PageView.swift
//  PageView
//
//  Created by 风起兮 on 2021/7/22.
//

import SwiftUI

struct PageView<Page: View & Identifiable>: View {
    
    @Binding var currentPage: Int
    var pages: [Page]
    
    var body: some View {
        GeometryReader { proxy in
           ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(pages) { page in
                            page
                                .frame(width: proxy.size.width, height: proxy.size.height)
                                .id(page.id)
                        }
                    }
                }
                .onReceive(currentPage.description.publisher) { item in
                    scrollProxy.scrollTo(pages[currentPage].id, anchor: .zero)
                }
            }
        }
    }
}

struct PageView_Previews: PreviewProvider {
    
    static var previews: some View {
        PageView(currentPage: .constant(6), pages: Store.share.items.map {Page(id: $0.id, model: $0)})
    }
}
