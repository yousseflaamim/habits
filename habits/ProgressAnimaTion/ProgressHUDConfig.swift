//
//  ProgressHUDConfig.swift
//  habits
//
//  Created by gio on 5/4/25.
//


import SwiftUI
import ProgressHUD

struct ProgressHUDConfig {
    static func configure() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorHUD = .systemGray
        ProgressHUD.colorBackground = .lightGray
        ProgressHUD.colorAnimation = .systemBlue
        ProgressHUD.colorProgress = .systemBlue
        ProgressHUD.colorStatus = .label
        ProgressHUD.mediaSize = 100
        ProgressHUD.marginSize = 50
        ProgressHUD.fontStatus = .boldSystemFont(ofSize: 24)

        if let successImage = UIImage(named: "success"),
           let errorImage = UIImage(named: "error") {
            ProgressHUD.imageSuccess = successImage
            ProgressHUD.imageError = errorImage
        }
    }
}
