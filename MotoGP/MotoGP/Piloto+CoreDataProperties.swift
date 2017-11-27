//
//  Piloto+CoreDataProperties.swift
//  MotoGP
//
//  Created by Juan Rodríguez Baeza on 24/11/17.
//  Copyright © 2017 Juan Rodríguez Baeza. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Piloto {

    @NSManaged var nombre: String?
    @NSManaged var escuderia: Escuderia?

}
