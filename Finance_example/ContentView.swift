//
//  ContentView.swift
//  Finance_example
//
//  Created by Gautam on 15/11/22.
//

import SwiftUI


struct ContentView: View {
    //    @State var transactionModel = TransactionModel.self
    @State var myId:String = "Gautam"
    @State private var showSheet = false
    @State  var isLoading: Bool = false
    @ObservedObject var viewModel = FirebaseServices();
    @State var showDeleteAlert:TransactionModel?
    @State private var selectedSection = true
    
    var body: some View {
        if(isLoading){
            ProgressView()
        }
        NavigationView {
            VStack{
                Text("Overview")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack{
                    Text("Balance")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.6))
                    Text("\(rupeeSign)\(viewModel.totalBalance)")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    //                    Button(action: {
                    //                        if(myId == "Gautam"){
                    //                            myId = "Other"
                    //                        } else{
                    //                            myId = "Gautam"}
                    //                    }){
                    //                        Text("Switch User")
                    //                            .foregroundColor(.white)
                    //                            .frame(width: 200, height: 40)
                    //                            .background(Color.blue)
                    //                            .cornerRadius(15)
                    //                            .padding()
                    //                    }
                    Picker("Selected section:", selection:Binding(get: {
                        myId == "Gautam"
                    }, set: {newVal in
                        myId = newVal ? "Gautam" : "Other"
                        downloadData()
                    })) {
                        Group {
                            Text("Gautam")
                                .tag(true)
                            Text("Other")
                                .tag(false)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .frame(height: 200)
                
                Divider()
                Text("Transaction History (\(viewModel.transactions.count))")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if(viewModel.transactions.isEmpty){
                    Text("No transactions found")
                        .frame(maxHeight: .infinity, alignment: .center)
                }
                List{
                    ForEach(viewModel.transactions,  id: \.self.hashValue){ transaction in
                        TransactionTile(myId: myId, transaction: transaction)
                        
                        .alert("Delete transaction?", isPresented: Binding(get: {showDeleteAlert != nil}, set: {newVal in
                                                   showDeleteAlert = newVal ? transaction : nil})) {
                                                       Button("Yes") {
                                                           Task{
                                                               if(showDeleteAlert != nil){
                                                                   await FirebaseServices().deleteTransaction(model: showDeleteAlert!)}
                                                               showDeleteAlert = nil
                                                           }
    
                                                       }
                                                       Button("No") { showDeleteAlert = nil }
                                                   }

                            .deleteDisabled(myId != transaction.name)
                       
                        
                    }
                    .onDelete{(indexPath) in
                        showDeleteAlert = viewModel.transactions[indexPath.first!]
                    }
                    
                }
                
                .task {
                    downloadData()
                }
                .refreshable {
                    downloadData()
                }
                .foregroundColor(.blue)
                
                
                Spacer()
                Button(action: {
                    showSheet.toggle()
                }){
                    Text("Add new transaction")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding()
                }
                .sheet(isPresented: $showSheet, onDismiss: {
                    Task{
                        downloadData()
                    }
                    
                }) {
                    AddTransactionView(name: myId)}
            }
            .padding()
        }
        Spacer()
    }
    
    //    func loadData() async{
    //        isLoading = true
    //        print(transactionModel)
    //        transactionModel.transactions =   await transactionModel.getTransactions(myId: myId) ?? []
    //        isLoading = false
    //    }
    
    func downloadData() {
        viewModel.fetchData(myId: myId);
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TransactionTile: View {
    let myId: String
    let transaction: TransactionModel
    
    var body: some View {
        let isMyValue:Bool = myId == transaction.name
        NavigationLink(destination:  TransactionView(myId: myId, transactionModel: transaction)
        )
        {
            HStack() {
                VStack(alignment: .leading){   Text("\(transaction.name)")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.6));   Text("\(transaction.reason ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.6))
                }
                Spacer();      Text("\(rupeeSign)\(transaction.amount)")
                    .font(.headline)
                    .foregroundColor(isMyValue ? Color.green : Color.red)
            }
        }
    }
}
