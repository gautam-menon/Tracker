//
//  FirebaseServices.swift
//  Finance_example
//
//  Created by Gautam on 10/12/22.
//

import Foundation
import FirebaseFirestore

class FirebaseServices: ObservableObject{
    let transactionCollection = "Transactions";
    private let db = Firestore.firestore()
    @Published var transactions = [TransactionModel]()
    @Published var totalBalance:Int = 0
    
    func uploadTransaction(model: TransactionModel) async{
        do {
            if let encoded = try? JSONEncoder().encode(model) {
                if let json = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String : Any]{
                    self.db.collection(transactionCollection).addDocument(data: json)
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    func deleteTransaction(model: TransactionModel) async{
        do {
            if(model.documentId != nil){
            try await self.db.collection(transactionCollection).document(model.documentId!).delete()
            }
        }
        catch {
            print(error)
        }
    }
    
    func fetchData(myId: String){
        db.collection(transactionCollection).getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.totalBalance = 0
            self.transactions = documents.map { (queryDocumentSnapshot) -> TransactionModel in
                let data = queryDocumentSnapshot.data()
                let amount:Int = data["amount"] as? Int ?? 0
                let transactionId:String = data["name"] as? String ?? ""
                if(myId == transactionId)
                {
                    self.totalBalance += amount
                }
                else
                {
                    self.totalBalance -= amount
                }
                let model: TransactionModel = TransactionModel(amount: amount, timeStamp: data["timeStamp"] as? String ?? "", name: transactionId, reason: data["reason"] as? String, documentId: queryDocumentSnapshot.documentID as String)
                return model
            }
        }
    }
}
