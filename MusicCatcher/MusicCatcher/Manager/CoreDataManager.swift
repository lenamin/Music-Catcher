//
//  CoreDataManager.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/25.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {
    }
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    /// 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    var audioEntityArray: [AudioEntity] = []
    let modelName: String = "AudioEntity"
    
    // MARK: - Create
    
    /// 새로운 audio를 만들고 저장한다
    /// audio(파라미터...) 넣어서 값이 있는 값만 넣을것
    func createAudioData(with audio: AudioModel, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                // 임시저장소에 올라갈 객체 생성
                if let audioCreated = NSManagedObject(entity: entity, insertInto: context) as? AudioEntity {
                    audioCreated.url = audio.url
                    audioCreated.title = audio.title
                    audioCreated.date = audio.date
                    audioCreated.folderName = audio.folderName
                    audioCreated.context = audio.context
                    audioCreated.tags = audio.tags
                    
                    self.appDelegate?.saveToContext()
                }
            }
        } else { return print("context없음") }
        completion()
    }
    
    // MARK: - Read
    
    func getAudioSavedArrayFromCoreData(completion: @escaping ([AudioEntity]) -> Void) {
        var savedAudioList: [AudioEntity] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            
            let date = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [date]
            
            do {
                if let fetchedAudioList = try context.fetch(request) as? [AudioEntity] {
                    savedAudioList = fetchedAudioList
                    print("CoreDataManager - savedAudioList: \(savedAudioList.map { $0.url })")
                }
                completion(savedAudioList)
            } catch {
                print("전체 데이터 가져오기실패")
                completion(savedAudioList)
            }
        }
    }
    
    // MARK: - Delete
    
    func deleteAudioData(entity: AudioEntity, completion: @escaping () -> Void) {
        guard let url = entity.url else { return }
        
        if let context = context {
            context.perform { [self] in
                let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
                
                request.predicate = NSPredicate(format: "url = %@",url as String)
                
                do {
                    if let fetchedAudioList = try context.fetch(request) as? [AudioEntity] {
                        if let targetAudio = fetchedAudioList.first {
                            context.delete(targetAudio)
                            self.appDelegate?.saveToContext()
                        }
                    }
                    completion()
                } catch {
                    print("삭제 실패")
                }
            }
        }
    }
    
    // MARK: - Update
    
    func updateAudio(with audioEntity: AudioEntity, completion: @escaping() -> Void) {
        
        guard let url = audioEntity.url else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            print("request: \(request)")
            request.predicate = NSPredicate(format: "url = %@", url as String)
            do {
                if let fetchedAudioList = try context.fetch(request) as? [AudioEntity] {
                    var targetAudio = fetchedAudioList.first
                    targetAudio = audioEntity
                    appDelegate?.saveToContext()
                }
                completion()
            } catch {
                print("update failed")
                completion()
            }
        }
    }
    
    enum CoreDataError: Error {
        case noContext
        case createFailed
        case readFailed
    }
}
