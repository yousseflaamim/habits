//
//  ViewE.swift
//  habits
//
//  Created by gio on 5/3/25.
//

import SwiftUI

extension View {
    func roundedBackground(cornerRadius: CGFloat = 12, color: Color = .gray.opacity(0.1)) -> some View {
        self
            .padding()
            .background(color)
            .cornerRadius(cornerRadius)
    }

    func titleStyle() -> some View {
        self
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.primary)
    }

    func subtitleStyle() -> some View {
        self
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}
