////
////  Theme.swift
////  Finance_example
////
////  Created by Gautam on 24/12/22.
////
//
//import Foundation
//import SwiftUI
//
//enum Theme: String {
//    case light
//    case dark
//    case black
//}
//
//class ThemeController {
//    private(set) var currentTheme: ColorScheme
//    private let defaults: UserDefaults
//    private let defaultsKey = "theme"
//
//    init(defaults: UserDefaults = .standard) {
//        self.defaults = defaults
//        self.currentTheme = loadTheme()
//    }
//
//    func changeTheme(to theme: ColorScheme) {
//        currentTheme = theme
//        defaults.setValue(theme, forKey: defaultsKey)
//    }
//
//    func loadTheme() -> Theme {
//        let rawValue = defaults.string(forKey: defaultsKey)
//        return rawValue.flatMap(Theme.init) ?? .light
//    }
//}
