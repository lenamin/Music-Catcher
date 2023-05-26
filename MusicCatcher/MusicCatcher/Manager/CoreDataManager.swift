//
//  CoreDataManager.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static var shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var myEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "AudioEntity", in: context)
    }
    
    func saveToContext() {
        do {
            try context.save()
        } catch {
            print("error saving to context : \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD methods
    
    /// Create
    func insertMyEntity(_ audio: AudioModel) {
        if let entity = myEntity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            /*
            managedObject.setValue(audio.title, forKey: "")
            managedObject.setValue(audio.url, forKey: "")
            managedObject.setValue(audio.date, forKey: "")
            managedObject.setValue(audio.duration, forKey: "")
            managedObject.setValue(audio.tags, forKey: "")
            managedObject.setValue(audio.folderName, forKey: "")
             */
            saveToContext()
        }
    }
    
    func saveAudioFileData(title: String, url: URL, duration: Int) {
        if let entity = myEntity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(title, forKey: "title")
            print("save succcess title : \(title)")
            managedObject.setValue(url, forKey: "url")
            print("save succcess url \(url)")
            managedObject.setValue(duration, forKey: "duration")
            print("save succcess duration \(duration)")
            saveToContext()
        }
    }
    
    /// Read
    func fetchAudioData() -> [AudioEntity] {
        do {
            let request = AudioEntity.fetchRequest()
            let results = try context.fetch(request)
            return results
        } catch {
            print("error fetching Audio : \(error.localizedDescription)")
        }
        return []
    }
    
    /// CoreData에 있는 data들을 AudioModel 형태로 반환
    func getAudioData() -> [AudioModel] {
        var audios: [AudioModel] = []
        let fetchResults = fetchAudioData()
        for result in fetchResults {
            // TODO: url String() 형식 URL로 변경하기
            
            let audioFileData = AudioModel(url: result.url!,
                                           title: result.title ?? "",
                                           tags: result.tags,
                                           date: result.title!,
                                           duration: Int(result.duration),
                                           context: result.context!,
                                           folderName: result.folderName ?? "")
            audios.append(audioFileData)
        }
        return audios
        
    }

    /// update AudioModelData
    func updateAudioData(_ audio: AudioModel) {
        let fetchResults = fetchAudioData()
        
        // TODO: 변경가능성 있는 것 -> title, tags, context, folderName (각각 다 따로 구현할것)
        for result in fetchResults {
            // 여기에 update 할 data들 넣어준다
        }
        saveToContext()
    }
    
    /// delete AudioDataModel
    func deleteAudioData(_ audio: AudioModel) {
        let fetchResults = fetchAudioData()
        let audioFileData = fetchResults.filter({ $0.url == audio.url })[0]
        context.delete(audioFileData)
        saveToContext()
    }
    
    func deleteAllAudioDatas() {
        let fetchResults = fetchAudioData()
        fetchResults.forEach { context.delete($0) }
        saveToContext()
    }
}
