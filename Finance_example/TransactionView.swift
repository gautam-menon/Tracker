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
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 20) {
                
                DetailsTile(title: "Name", content: transactionModel.name);
                DetailsTile(title: "Amount", content: "\(transactionModel.amount)");
                if(transactionModel.reason.isTrulyNotEmpty())    { DetailsTile(title: "Reason", content: transactionModel.reason!)}
                DetailsTile(title: "Date", content: "\(transactionModel.timeStamp)")
                if(myId == transactionModel.name){
                Button(action: {
                    //   showSheet.toggle()
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
