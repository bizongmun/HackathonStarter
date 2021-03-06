//
//  Realm+.swift
//  HackathonStarter
//
//  Created by 田中　達也 on 2016/07/20.
//  Copyright © 2016年 tattn. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmType {}
extension Object: RealmType {}
extension Array: RealmType {}


private func realmBlock(@noescape block: Realm throws -> Void) -> Bool {
    do {
        try block(try Realm())
        return true
    } catch {
        print(error)
    }
    return false
}


// MARK:- Write
extension RealmType where Self: Object {

    func write(@noescape block: Realm -> Void) -> Bool {
        return realmBlock { realm in
            try realm.write {
                block(realm)
            }
        }
    }

    func save() -> Bool {
        return write { realm in
            realm.add(self, update: true)
        }
    }

    func saveAsync() {
        threadOnBackground("realm-background") {
            self.save()
        }
    }

}

extension Array where Element: Object {

    func write(@noescape block: Realm -> Void) -> Bool {
        return realmBlock { realm in
            try realm.write {
                block(realm)
            }
        }
    }

    func save() -> Bool {
        return write { realm in
            realm.add(self, update: true)
        }
    }

    func saveAsync() {
        threadOnBackground("realm-background") {
            self.save()
        }
    }
}


// MARK:- Read
extension RealmType where Self: Object {

    static func all() -> [Self] {
        if let realm = try? Realm() {
            return Array(realm.objects(Self))
        }
        return []
    }

    static func findAll(predicateFormat: String, _ args: AnyObject...) -> [Self] {
        if let realm = try? Realm() {
            return Array(realm.objects(Self).filter(predicateFormat, args))
        }
        return []
    }
}


// MARK:- Delete
extension RealmType where Self: Object {
    static func deleteAll(predicateFormat: String, _ args: AnyObject...) -> Bool {
        return realmBlock { realm in
            let results = realm.objects(Self).filter(predicateFormat, args)
            
            try realm.write {
                realm.delete(results)
            }
        }
    }

    func delete() -> Bool {
        return write { realm in
            realm.delete(self)
        }
    }
}

extension Array where Element: Object {
    func delete() -> Bool {
        return write { realm in
            realm.delete(self)
        }
    }
}
