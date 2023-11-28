//
//  TabBarController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/07.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.pointColor], for: .selected)
        UITabBar.appearance().tintColor = .pointColor
        UITabBar.appearance().backgroundColor = .custombackgroundGrayColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // record tap
        let recordViewTab = UINavigationController(rootViewController: ReadyRecordViewController())
        let recordViewTabBarItem = UITabBarItem(title: "녹음",
                                                image: micImage,
                                                selectedImage: micFillImage)
        
        recordViewTab.tabBarItem = recordViewTabBarItem
        
        // file tab
        let fileViewTab = UINavigationController(rootViewController: FileGroupViewController())
        let fileViewTabBarItem = UITabBarItem(title: "파일",
                                              image: fileImage,
                                              selectedImage: fileFillImage)
        fileViewTab.navigationController?.navigationBar.isHidden = false
        fileViewTab.tabBarItem = fileViewTabBarItem
        
        // analysis
        let analysisTab = UINavigationController(rootViewController:AnalysisViewController())
        let favoriateTabBarItem = UITabBarItem(title: "분석",
                                               image: analysisImage,
                                               selectedImage: analysisImage)
        
        analysisTab.tabBarItem = favoriateTabBarItem
        
        // setting tab
        let settingTab = UINavigationController(rootViewController: SettingTableViewController())
        let settingViewTabBarItem = UITabBarItem(title: "설정",
                                                 image: gearImage,
                                                 selectedImage: gearFillImage)
        
        settingTab.tabBarItem = settingViewTabBarItem
        
        self.viewControllers = [recordViewTab, fileViewTab, analysisTab, settingTab]
    }
}

