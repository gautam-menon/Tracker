//
//  transactionModel.swift
//  Finance_example
//
//  Created by Gautam on 29/11/22.
//

import Foundation
import FirebaseFirestore

struct TransactionModel:Hashable, Codable{
    
    static var selectedId:String = "Gautam"
    
    var amount:Int
    var timeStamp:Double
    var name:String
    var reason:String?
    var documentId:String?
    
    static var transactions: [TransactionModel] = []
    
    static func addTransaction(model: TransactionModel) async{
        Task {
            try await Task.sleep(for: .microseconds(500))
            print("\(model)")
            if let encoded = try? JSONEncoder().encode(model) {
                UserDefaults.standard.set(encoded, forKey: "SavedData")
            }
        }
    }
    
    static func getTransactions(myId: String) async ->[TransactionModel]? {
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode(TransactionModel.self, from: data) {
                print(decoded)
                return [decoded]
            }
        }
        return nil;
    }
}

extension TransactionModel{
    static let samples = [
        TransactionModel(amount: 100, timeStamp: 234, name: "Gautam", reason: "Movie", documentId: ""),
        TransactionModel(amount: 150, timeStamp: 324, name: "Bob", documentId: ""),
        TransactionModel(amount: 120, timeStamp:234, name: "You",reason: "Food", documentId: ""),
        TransactionModel(amount: 120, timeStamp: 23432, name: "You",reason: "Food", documentId: ""),
    ]
}
