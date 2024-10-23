//
//  FirebaseManager.swift
//  FruitHub
//
//  Created by Vlad on 22.10.24.
//

import Foundation
import Combine
import FirebaseFirestore

protocol FirebaseManagerProtocol: AnyObject {
    func getAllFruitsSalad() -> AnyPublisher<Result<[FruitSalad], Error>, Never>
}

final class FirebaseManager: FirebaseManagerProtocol {
    
    let reference = Firestore.firestore()
    
    func getAllFruitsSalad() -> AnyPublisher<Result<[FruitSalad], Error>, Never> {
        return Future<Result<[FruitSalad], Error>, Never> { [weak self] promise in
            self?.reference.collection("FruitSalad").getDocuments { snapshot, error in
                guard error == nil else {
                    let error = NSError(domain: "Error when receiving documents: \(error?.localizedDescription ?? "Unknown error")", code: 0)
                    promise(.success(.failure(error)))
                    return
                }
                guard let snapshot = snapshot else {
                    let error = NSError(domain: "Snapshot is nill", code: 0)
                    promise(.success(.failure(error)))
                    return
                }
                guard !snapshot.documents.isEmpty else {
                    let error = NSError(domain: "No internet connection", code: 1)
                    promise(.success(.failure(error)))
                    return
                }
                var fruitSalads: [FruitSalad] = []
                for document in snapshot.documents {
                    let data = document.data()
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let fruidSalad = try JSONDecoder().decode(FruitSalad.self, from: jsonData)
                        fruitSalads.append(fruidSalad)
                    } catch let jsonError{
                        promise(.success(.failure(jsonError)))
                    }
                }
                promise(.success(.success(fruitSalads)))
            }
        }
        .eraseToAnyPublisher()
    }
}
