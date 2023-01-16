//
//  PhoneNumbersListItem+CoreDataProperties.swift
//  PhoneNubersCoreData
//
//  Created by Irakli Nozadze on 19.12.22.
//
//

import Foundation
import CoreData


extension PhoneNumbersListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneNumbersListItem> {
        return NSFetchRequest<PhoneNumbersListItem>(entityName: "PhoneNumbersListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?

}

extension PhoneNumbersListItem : Identifiable {

}
