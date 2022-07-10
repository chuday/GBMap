//
//  RealmService.swift
//  GBMaps
//
//  Created by Mikhail Chudaev on 03.07.2022.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    func add(models: [Object])
    func read(object: Object.Type) -> [Object]
    func delete(object: Object.Type)
}

class RealmService: RealmServiceProtocol {
    
    let config = Realm.Configuration(schemaVersion: 2)
    lazy var realm = try! Realm(configuration: config)
    
    func add(models: [Object]) {
        do {
            self.realm.beginWrite()
            self.realm.add(models, update: .modified)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func add(model: Object) {
        do {
            self.realm.beginWrite()
            self.realm.add(model, update: .modified)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func read(object: Object.Type) -> [Object] {
        let models = self.realm.objects(object)
        
        return Array(models)
    }
    
    func read(object: Object.Type, filter: String) -> [Object] {
        let models = realm.objects(object).filter(filter)

        return Array(models)
    }

    
    func delete(object: Object.Type) {
        let models = self.realm.objects(object)
        
        do {
            self.realm.beginWrite()
            self.realm.delete(models)
            try self.realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
}
