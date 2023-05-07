//
//  Widgets.swift
//  Finance_example
//
//  Created by Gautam on 15/12/22.
//
import SwiftUI

struct PersonTile: View {
    let color: Color
    let name: String
    let isSelected: Bool
    var body: some View {
        VStack{
            Text(name.uppercased().prefix(1))
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(isSelected ? color: .white)
                .background(isSelected ? .white: color)
                .clipShape(Circle())
                .frame(maxWidth: .infinity, alignment: .center)
            Text(name.capitalized)
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .white: color)
        }
        .padding()
        .background(isSelected ? color: .white)
        .cornerRadius(15)
    }
}
