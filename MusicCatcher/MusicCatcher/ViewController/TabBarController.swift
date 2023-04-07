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
        let recordViewTab = ReadyRecordViewController()
        let recordViewTabBarItem = UITabBarItem(title: "record",
                                                image: micImage,
                                                selectedImage: micFillImage)
        
        recordViewTab.tabBarItem = recordViewTabBarItem
        
        // file tab
        let fileViewTab = ReadyRecordViewController()
        let fileViewTabBarItem = UITabBarItem(title: "file",
                                              image: fileImage,
                                              selectedImage: fileFillImage)
        
        
        fileViewTab.tabBarItem = fileViewTabBarItem
        
        // favoriate tab
        let favoriateTab = ReadyRecordViewController()
        let favoriateTabBarItem = UITabBarItem(title: "favoriate",
                                               image: heartImage,
                                               selectedImage: heartFillImage)
        
        favoriateTab.tabBarItem = favoriateTabBarItem
        
        // setting tab
        let settingTab = ReadyRecordViewController()
        let settingViewTabBarItem = UITabBarItem(title: "setting",
                                                 image: gearImage,
                                                 selectedImage: gearFillImage)
        
        settingTab.tabBarItem = settingViewTabBarItem
        // TODO: 파일, 즐겨찾기, 세팅 뷰컨트롤러 추가하기
        
        self.viewControllers = [recordViewTab, fileViewTab, favoriateTab, settingTab]
        
        
           
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // TODO: 탭바아이템 선택했을 떄 화면 전환 구현하기
        print("tabbar가 선택되었습니다")
    }
}

