//
//  PageBar.swift
//  PageBar
//
//  Created by 风起兮 on 2021/7/21.
//

import SwiftUI

struct PageBar: View {
    
    public struct Item {
        let title: String
    }
    
    struct ItemView: View {
        
        let item: Item
        let isSelected: Bool
        
        var body: some View {
            Text(item.title)
                .scaleEffect(isSelected ? 1.5 : 1.0)
                .font(.title3)
                .foregroundColor(isSelected ? .primary : .secondary)
                .padding(.all, 10)
                .anchorPreference(key: PageItemPreferenceKey.self, value: .bounds) { [.init(pageItem: item, bounds: $0)] }
                .transformAnchorPreference(key: PageItemPreferenceKey.self, value: .topLeading, transform: { (value: inout [PageItemPreferenceData], anchor: Anchor<CGPoint>) in
                    value[0].topLeading = anchor
                })
        }
    }
    
   @Binding public var currentIndex: Int
    
    let items: [Item]
    
    var body: some View {
        HStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(items, id:  \.title) { item in
                            ItemView(item: item, isSelected: item.title == items[currentIndex].title )
                                .id(item.title)
                                .onTapGesture {
                                    withAnimation {
                                        self.currentIndex = items.firstIndex{$0.title == item.title}!
                                    }
                                }
                        }
                    }
                }
                .backgroundPreferenceValue(PageItemPreferenceKey.self) { preferences in
                    GeometryReader { proxy in
                        self.createBottomLine(proxy, preferences: preferences)
                    }
                }
                .onReceive(currentIndex.description.publisher) { index in
                    withAnimation {
                        proxy.scrollTo(items[currentIndex].title, anchor: .center)
                    }
                }
            }
        }
        .padding(.horizontal)
        .background(.bar)
    }
    
    
    private func createBottomLine(_ proxy: GeometryProxy, preferences: [PageItemPreferenceData]) -> some View {
        
        let p = preferences[currentIndex]
        
        let bounds = proxy[p.bounds]
        
        let lineWidth = min(bounds.width, 20.0)
        
        let lineBounds =  bounds.insetBy(dx: (bounds.size.width - lineWidth) / 2.0 , dy: 0)
    
        return LinearGradient.init(colors: [Color.orange, Color.red], startPoint: .leading, endPoint: .trailing)
            .frame(width: lineWidth, height: 3)
            .clipShape(Capsule())
            .offset(x: lineBounds.minX, y: bounds.height - 5)
    }
}

struct PageItemPreferenceData {
    let pageItem: PageBar.Item
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
            PageBar(currentIndex: .constant(1), items: [PageBar.Item.init(title: "fdfd")])
            Spacer()
        }

    }
}
