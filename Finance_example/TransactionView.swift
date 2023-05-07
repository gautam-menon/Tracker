//
//  TransactionView.swift
//  Finance_example
//
//  Created by Gautam on 09/12/22.
//

import SwiftUI

struct TransactionView: View {
    let myId: String
    let  transactionModel: TransactionModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 20) {
                
                DetailsTile(title: "Name", content: transactionModel.name);
                DetailsTile(title: "Amount", content: "\(transactionModel.amount.convertToPositive())");
                if(transactionModel.reason.isTrulyNotEmpty())    { DetailsTile(title: "Reason", content: transactionModel.reason!)}
                DetailsTile(title: "Date", content: "\(Date(timeIntervalSince1970:(transactionModel.timeStamp)).formatted(date: .abbreviated, time: .shortened))")
                if(myId == transactionModel.name){
                    Button(action: {
                        Task {
                            await FirebaseServices().deleteTransaction(model: transactionModel)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }){
                        Text("Delete")
                            .padding(.horizontal)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .tint(.red)}
            }
            // .navigationTitle("Transaction Details")
            //.font(.caption)
        }
        
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(myId: "Gautam",transactionModel: TransactionModel.samples.first!)
    }
}

struct DetailsTile: View {
    let title: String
    let content: String
    var body: some View {
        VStack{
            Text(title)
                .foregroundColor(.gray)
                .font(.title3)
            Text(content)
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}
