//
//  StatsView.swift
//  habits
//
//  Created by gio on 4/30/25.
//


import SwiftUI

struct StatsView: View {
    let stats: [HabitStats]

    var body: some View {
        List(stats.indices, id: \.self) { index in
            VStack(alignment: .leading) {
                Text("Usually \(index + 1)")
                Text("Rate: \(String(format: "%.0f%%", stats[index].completionRate * 100))")
                Text("String: \(stats[index].streak) days")
            }
        }
        .navigationTitle("Statistics")
    }
}
