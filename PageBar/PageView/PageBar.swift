//
//  PageBar.swift
//  PageBar
//
//  Created by 风起兮 on 2021/7/21.
//

import SwiftUI

struct PageBarItem: Identifiable {
    var id: String { title }
    let title: String
}

struct PageBarItemView: View {
    
    let item: PageBarItem
    let isSelected: Bool
    
    var body: some View {
        Text(item.title)
            .font(.subheadline)
            .foregroundColor(isSelected ? .primary : .secondary)
            .anchorPreference(key: PageItemPreferenceKey.self, value: .bounds) { [.init(pageItem: item, bounds: $0)] }
            .transformAnchorPreference(key: PageItemPreferenceKey.self, value: .topLeading, transform: { (value: inout [PageItemPreferenceData], anchor: Anchor<CGPoint>) in
                value[0].topLeading = anchor
            })
    }
}


struct PageBar: View {
    
    
    var items: [PageBarItem]
    
    @Binding public var currentIndex: Int
    
    var body: some View {
      
        VStack(spacing: 0) {
            HStack {
                Group {
                    Button(action: {}) {
                       Image(systemName: "loupe")
                           .foregroundColor(.secondary)
                    }
                }
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(items.indices) { index in
                                let item = items[index]
                                let isSelected = item.id == items[currentIndex].id
                                PageBarItemView(item: item, isSelected: isSelected)
                                    .onTapGesture {
                                        self.currentIndex = index
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                        .backgroundPreferenceValue(PageItemPreferenceKey.self) { preferences in
                            GeometryReader { proxy in
                                self.createIndicator(proxy, preferences: preferences)
                            }
                        }
                    }
                }
                
                Group {
                    Button(action: {}) {
                       Image(systemName: "slider.horizontal.3")
                           .foregroundColor(.secondary)
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
        let lineWidth = min(bounds.width, 16.0)
        let lineBounds =  bounds.insetBy(dx: (bounds.size.width - lineWidth) / 2.0 , dy: 0)
    
        return LinearGradient(colors: [Color.orange, Color.red], startPoint: .leading, endPoint: .trailing)
            .frame(width: lineWidth, height: 3)
            .clipShape(Capsule())
            .offset(x: lineBounds.minX, y: proxy.size.height - 3 )
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
                .controlSize(.large)
            Spacer()
        }

    }
}
