//
//  CustomProgressView.swift
//  habits
//
//  Created by gio on 5/8/25.
//


//
//  ProgressView.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import SwiftUI

struct CustomProgressView
: View {
    let progress: Double

    var body: some View {
        VStack(spacing: 16) {
            Text("General Progress")
                .font(.headline)

            SwiftUI.ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .padding()

            Text("\(Int(progress * 100))% Complete")
        }
    }
}
