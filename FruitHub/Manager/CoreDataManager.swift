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

protocol CoreDataSaving: AnyObject {
    func saveContext() throws
}

protocol CoreDataCreationUser: AnyObject {
    func createUser(user: User) -> AnyPublisher<Void, Error>
}

protocol CoreDataReceivingUser: AnyObject {
    func fetchUser() -> AnyPublisher<User, Error>
}

protocol CoreDataFruitSalads: AnyObject {
    func createFruitSalads(fruitSalads: [FruitSalad]) -> AnyPublisher<Void, Error>
    func fetchFruitSalads() -> AnyPublisher<[FruitSalad], Error>
    func removeAllFruitSalads() -> AnyPublisher<Void, Error>
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
    func fetchUser() -> AnyPublisher<User, Error> {
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

//MARK: CoreDataCreationFruitSalad
extension CoreDataManager: CoreDataFruitSalads {
        
    func createFruitSalads(fruitSalads: [FruitSalad]) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            self.backgroundContext.perform {
                for fruitSalad in fruitSalads {
                    let fruitSaladModel = FruitSaladModel(context: self.backgroundContext)
                    fruitSaladModel.id = fruitSalad.id
                    fruitSaladModel.imageUrl = fruitSalad.imageUrl
                    fruitSaladModel.nameSalad = fruitSalad.nameSalad
                    fruitSaladModel.price = fruitSalad.price
                    fruitSaladModel.isFavorite = fruitSalad.isFavorite
                    fruitSaladModel.compound = fruitSalad.compound
                    fruitSaladModel.descript = fruitSalad.description
                    fruitSaladModel.isRecommended = fruitSalad.isRecommended
                    fruitSaladModel.isFruitSalad = fruitSalad.isFruitSalad
                    fruitSaladModel.isExoticSalad = fruitSalad.isExoticSalad
                    fruitSaladModel.isCitrusSalad = fruitSalad.isCitrusSalad
                    fruitSaladModel.isSeasonSalad = fruitSalad.isSeasonSalad
                    fruitSaladModel.isBasket = fruitSalad.isBasket
                    fruitSaladModel.packaging = Int16(fruitSalad.packaging)
                }
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
    
    func fetchFruitSalads() -> AnyPublisher<[FruitSalad], Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            self.backgroundContext.perform {
                let fetchRequest = FruitSaladModel.fetchRequest()
                do {
                    let fruitSaladModels = try self.backgroundContext.fetch(fetchRequest)
                    var fruitSalads: [FruitSalad] = []
                    for fruitSaladModel in fruitSaladModels {
                        fruitSalads.append(FruitSalad(id: fruitSaladModel.id ?? "",
                                                      imageUrl: fruitSaladModel.imageUrl ?? "",
                                                      nameSalad: fruitSaladModel.nameSalad ?? "",
                                                      price: fruitSaladModel.price,
                                                      isFavorite: fruitSaladModel.isFavorite,
                                                      compound: fruitSaladModel.compound ?? "",
                                                      description: fruitSaladModel.descript ?? "",
                                                      isRecommended: fruitSaladModel.isRecommended,
                                                      isFruitSalad: fruitSaladModel.isFruitSalad,
                                                      isExoticSalad: fruitSaladModel.isExoticSalad,
                                                      isCitrusSalad: fruitSaladModel.isCitrusSalad,
                                                      isSeasonSalad: fruitSaladModel.isSeasonSalad,
                                                      isBasket: fruitSaladModel.isBasket,
                                                      packaging: Int(fruitSaladModel.packaging)))
                    }
                    promise(.success(fruitSalads))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func removeAllFruitSalads() -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            self.backgroundContext.perform {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FruitSaladModel")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try self.backgroundContext.execute(batchDeleteRequest)
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
