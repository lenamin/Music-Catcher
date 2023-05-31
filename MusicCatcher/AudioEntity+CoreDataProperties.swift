//
//  AudioEntity+CoreDataProperties.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/29.
//
//

import Foundation
import CoreData


extension AudioEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AudioEntity> {
        return NSFetchRequest<AudioEntity>(entityName: "AudioEntity")
    }

    @NSManaged public var context: String?
    @NSManaged public var date: String?
    @NSManaged public var folderName: String?
    @NSManaged public var tags: [String]?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}

extension AudioEntity : Identifiable {

}
