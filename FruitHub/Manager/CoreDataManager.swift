//
//  CoreDataManager.swift
//  FruitHub
//
//  Created by Vlad on 28.10.24.
//

import Foundation
import CoreData
import Combine
import UIKit

protocol CoreDataSaving {
    func saveContext() throws
}

protocol CoreDataCreationUser {
    func createUser(user: User) -> AnyPublisher<Void, Error>
}

protocol CoreDataReceivingUser {
    func readUser() -> AnyPublisher<User, Error>
}

final class CoreDataManager {
    
    private let persistentContainer: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext
    
    init() {
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
    }
}

//MARK: CoreDataSaving
extension CoreDataManager: CoreDataSaving {
    func saveContext() throws {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                let error = error as NSError
                throw error
            }
        }
    }
}

//MARK: CoreDataCreationUser
extension CoreDataManager: CoreDataCreationUser {
    func createUser(user: User) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            self.backgroundContext.perform {
                let newUser = UserModel(context: self.backgroundContext)
                newUser.name = user.name
                do {
                    try self.saveContext()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

//MARK: CoreDataReceivingUser
extension CoreDataManager: CoreDataReceivingUser {
    func readUser() -> AnyPublisher<User, Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            backgroundContext.perform {
                let fetchRequest = UserModel.fetchRequest()
                do {
                    let usersModel = try self.backgroundContext.fetch(fetchRequest)
                    print(usersModel)
                    guard let name = usersModel.last?.name else {
                        let error = NSError(domain: "Failed to get user", code: 0)
                        promise(.failure(error))
                        return
                    }
                    let user = User(name: name)
                    promise(.success(user))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
