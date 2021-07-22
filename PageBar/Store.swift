//
//  Model.swift
//  PageBar
//
//  Created by 风起兮 on 2021/7/21.
//
import SwiftUI
import Combine

struct Model: Identifiable {
    let id: UUID = .init()
    var title: String
}


class Store: ObservableObject {
    
    static let share = Store()
    
    @Published var items = ["推荐", "要闻", "视频", "抗疫", "北京", "新时代", "娱乐", "体育", "军事", "NBA", "科技", "财经", "时尚"]
        .map (Model.init(title:))
    
}
