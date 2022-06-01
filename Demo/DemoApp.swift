//
//  DemoApp.swift
//  Demo
//
//  Created by tingyang on 2022/5/30.
//

import SwiftUI
import Firebase
@main
struct DemoApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            SignIn()
        }
    }
}
