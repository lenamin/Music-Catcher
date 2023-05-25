//
//  RecordFileManager.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/12.
//


import UIKit
import AVFoundation


class RecordFileManager {
    
    static let shared = RecordFileManager()
    
    let fileManager = FileManager.default
    var documentDirectory: URL?
    var fileList: Array<Any>? = nil
    var recorder = Recorder()
    var recordName: Observable<String> = Observable("default")
    var myURL: URL?
    
    init() {
        setup()
    }
    
    func getDocumentDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setup() {
        guard
            let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first
        else {
            print("FileManager init Directory Error")
            return
        }
        self.documentDirectory = documentDirectory.appendingPathComponent("recordings")
    }
    
    public func setRecordName() {
        recordName.value = MyDateFormatter.shared.dateToString(from: Date.now)
        print("recordName.value = \(recordName.value)")
    }
    /*
    func getFileURL() -> URL {
        let path = getDocumentDirectory().appendingPathComponent(setRecordName())
        return path as URL
    }
     */
    
    private func createDirectory() {
        guard let documentDirectory = documentDirectory else { return }
        if fileManager.fileExists(atPath: documentDirectory.path) == false {
            do {
                try fileManager.createDirectory(atPath: documentDirectory.path,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                print("Create Record Directory Error")
            }
        }
    }
    
    func saveRecordFile(recordName: String, file: URL) {
        guard let documentDirectory = documentDirectory else { return }
        createDirectory()
        let recordURL = documentDirectory.appendingPathComponent("\(recordName).m4a")
        do {
            let data = try Data(contentsOf: file)
            try data.write(to: recordURL)
            self.myURL = recordURL
            print("save success: \(recordName)")
            print("newURL= \(myURL)")
        } catch {
            print("Save Data Error")
        }
    }
    
    func loadRecordFile(_ url: URL) -> AVAudioFile? {
        guard let documentDirectory = documentDirectory else { return nil }
        createDirectory()
        do {
            let recordfile = try AVAudioFile(forReading: url)
            print("loadRecordFile func excuted: \(recordfile.url)")
            return recordfile
        } catch {
            print("Loading Data from FileManager fail: \(url)")
            return nil
        }
    }
    
    func deleteRecordFile(_ recordName: String) {
        guard let documentDirectory = documentDirectory else { return }
        createDirectory()
        let recordURL = documentDirectory.appendingPathComponent("\(recordName).m4a")
        if fileManager.fileExists(atPath: recordURL.path) {
            do {
                try fileManager.removeItem(at: recordURL)
                print("Delete Success")
            }
            catch {
                print("Delete Fail")
            }
        }
    }
}


