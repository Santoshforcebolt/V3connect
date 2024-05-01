//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation

struct SettingModel: Hashable {
    let id = UUID()
    let imageName: String
    let detailName: SettingsEnum
}

let settingsData: [SettingModel] = [
//    SettingModel(imageName: "bell.fill", detailName: .notification),
//    SettingModel(imageName: "questionmark.circle", detailName: .help),
    SettingModel(imageName: "trash.circle", detailName: .logout),
]
