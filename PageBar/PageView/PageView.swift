/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view for bridging a UIPageViewController.
*/

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            PageViewController(pages: pages, currentPage: $currentPage)
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 18))
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(pages: Store.share.items.map {Page(id: $0.id, model: $0)})
    }
}
