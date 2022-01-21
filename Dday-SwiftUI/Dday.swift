//
//  Dday.swift
//  Dday-SwiftUI
//
//  Created by 박성헌 on 2019/12/14.
//  Copyright © 2019 n30gu1. All rights reserved.
//
import Foundation
import CoreData

public class Dday: NSManagedObject, Identifiable {
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var startFromDayOne: Bool
}

extension Dday {
    static func fetchAllItems() -> NSFetchRequest<Dday> {
        let request: NSFetchRequest<Dday> = Dday.fetchRequest() as! NSFetchRequest<Dday>
        
        request.sortDescriptors = []
        return request
    }
}
