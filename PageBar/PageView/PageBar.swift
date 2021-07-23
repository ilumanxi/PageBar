//
//  PageBar.swift
//  PageBar
//
//  Created by 风起兮 on 2021/7/21.
//

import SwiftUI

struct PageBarItem: Equatable, Hashable {
    let title: String
}

struct PageBarItemView: View {
    
    let item: PageBarItem
    let isSelected: Bool
    
    var body: some View {
        Text(item.title)
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .font(.subheadline)
            .foregroundColor(isSelected ? .primary : .secondary)
            .padding(.horizontal, 10)
            .anchorPreference(key: PageItemPreferenceKey.self, value: .bounds) { [.init(pageItem: item, bounds: $0)] }
            .transformAnchorPreference(key: PageItemPreferenceKey.self, value: .topLeading, transform: { (value: inout [PageItemPreferenceData], anchor: Anchor<CGPoint>) in
                value[0].topLeading = anchor
            })
    }
}


struct PageBar: View {
    
    
    let items: [PageBarItem]
    @Binding public var currentIndex: Int
    
    var body: some View {
        VStack {
            HStack {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(items.indices) { index in
                                let item = items[index]
                                PageBarItemView(item: item, isSelected: item == items[currentIndex])
                                    .id(item)
                                    .onTapGesture {
                                        self.currentIndex = index
                                    }
                            }
                        }
                    }
                    .backgroundPreferenceValue(PageItemPreferenceKey.self) { preferences in
                        GeometryReader { proxy in
                            self.createIndicator(proxy, preferences: preferences)
                        }
                    }
                    .onChange(of: currentIndex) { index in
                        // Later processing is shown in the center
                        proxy.scrollTo(items[index], anchor: .center)
                    }
                }
            }
            .padding(.horizontal)
           
            Divider()
        }
        .background(.bar)
    }
    
    private func createIndicator(_ proxy: GeometryProxy, preferences: [PageItemPreferenceData]) -> some View {
                
        let p = preferences[currentIndex]
        
        let bounds = proxy[p.bounds]
        
        let lineWidth = min(bounds.width, 20.0)
        
        let lineBounds =  bounds.insetBy(dx: (bounds.size.width - lineWidth) / 2.0 , dy: 0)
    
        return LinearGradient.init(colors: [Color.orange, Color.red], startPoint: .leading, endPoint: .trailing)
            .frame(width: lineWidth, height: 3)
            .clipShape(Capsule())
            .offset(x: lineBounds.minX, y: bounds.height + 3)
    }
}

struct PageItemPreferenceData {
    let pageItem: PageBarItem
    let bounds: Anchor<CGRect>
    var topLeading: Anchor<CGPoint>? = nil
}

struct PageItemPreferenceKey: PreferenceKey {

    static var defaultValue: [PageItemPreferenceData] = []
    
    static func reduce(value: inout [PageItemPreferenceData], nextValue: () -> [PageItemPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}


struct PageBar_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            PageBar(items: Store.share.items.map(\.title).map(PageBarItem.init(title:)), currentIndex: .constant(1))
            Spacer()
        }

    }
}
