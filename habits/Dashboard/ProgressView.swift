//
//  ProgressView.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import SwiftUI

struct ProgressView: View {
    let progress: Double

    var body: some View {
        VStack(spacing: 16) {
            Text("التقدم العام")
                .font(.headline)

            SwiftUI.ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .padding()

            Text("\(Int(progress * 100))% Complete")
        }
    }
}
