//
//  PageBarApp.swift
//  PageBar
//
//  Created by 风起兮 on 2021/7/21.
//

import SwiftUI

@main
struct PageBarApp: App {
    
    @StateObject var store = Store.share
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
