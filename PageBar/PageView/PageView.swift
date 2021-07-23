/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view for bridging a UIPageViewController.
*/

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @Binding var currentPage: Int
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(pages.indices) { index in
                pages[index]
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(pages: Store.share.items.map {Page(id: $0.id, model: $0)}, currentPage: .constant(Int.random(in: 0..<Store.share.items.count)))
    }
}
