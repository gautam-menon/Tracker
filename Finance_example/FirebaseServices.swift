//
//  FirebaseServices.swift
//  Finance_example
//
//  Created by Gautam on 10/12/22.
//

import Foundation
import FirebaseFirestore

class FirebaseServices: ObservableObject{
//    let transactionCollection = "Transactions";
    let transactionCollection = "TransactionsCollection";
    let notesCollection = "NotesCollection"
    
    private let db = Firestore.firestore()
    
    @Published var transactions = [TransactionModel]()
    @Published var notes = [NotesModel]()
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
    
    func addNoteToDB(model: NotesModel) async{
        do {
            if let encoded = try? JSONEncoder().encode(model) {
                if let json = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String : Any]{
                    if(model.documentId == nil){
                        self.db.collection(notesCollection).addDocument(data: json)
                    }
                    else{
                        try await self.db.collection(notesCollection).document(model.documentId!).updateData(json)
                    }
                    
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
    
    func fetchData(myId: String, sortParam: String, desc: Bool, onlyMyTransactions: Bool){
        if(onlyMyTransactions){
            db.collection(transactionCollection).whereField("name", isNotEqualTo: myId).getDocuments()
            { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.addData(documents: documents, myId: myId)
            }
        }else{
            db.collection(transactionCollection).order(by:sortParam, descending: desc).getDocuments()
            { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.addData(documents: documents, myId: myId)
            }
            
        }
    }
    
    private func addData(documents: [QueryDocumentSnapshot], myId:String){
        self.totalBalance = 0
        self.transactions = documents.map { (queryDocumentSnapshot) -> TransactionModel in
            let data = queryDocumentSnapshot.data()
            let amount:Int = data["amount"] as? Int ?? 0
            let transactionId:String = data["name"] as? String ?? ""
            if(myId == transactionId){
                self.totalBalance += amount
            }
            else{
                self.totalBalance -= amount
            }
            let model: TransactionModel = TransactionModel(amount: amount, timeStamp: data["timeStamp"] as? Double ?? 0, name: transactionId, reason: data["reason"] as? String, documentId: queryDocumentSnapshot.documentID as String)
            return model
        }
    }
    func getNotes(sortString sort:String){
        db.collection(notesCollection).getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.notes = documents.map{
                val in
                let data = val.data()
                return NotesModel(title: data["title"] as? String ?? "", body: data["body"] as? String ?? "", timeStamp: data["timeStamp"] as? Double ?? 0, ownerUid: data["ownerUid"] as? String ?? "", documentId: val.documentID as String)
            }
        }
    }
//    func fixIds(){
//
//       db.collection(transactionCollection).getDocuments() { (querySnapshot, error) in
//           if let error = error {
//                  print("Error getting documents: \(error)")
//              }
//           print("\(querySnapshot?.count ?? 56)")
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                return
//            }
//            for doc in documents {
//                var dat = doc.data()
//                if(dat["name"] as! String=="OtherId"){
//                    dat["name"] = "Khushee"
//                }
////                dat["name"] = {
////                    if(dat["name"] as! String=="OtherId"){
////                        print(dat)
////                    }else{
////                        print("me")
////                    }
////                }
//                self.db.collection(self.newTransactionCollection).document(doc.documentID).setData(dat)
//            }
//        }
//    }
}
