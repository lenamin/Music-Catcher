//
//  FileName.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/29.
//

import UIKit

class FileName {
    public static let audioDirectoryName = "audio"
    public static let recordingInitAudioURL = URL(
        string: "date_formatter로_날짜넣어서_파일이름만들기.mp3",
        relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    )!
    
}
