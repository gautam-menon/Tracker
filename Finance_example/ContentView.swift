//
//  ContentView.swift
//  Finance_example
//
//  Created by Gautam on 15/11/22.
//

import SwiftUI


struct ContentView: View {
    let myId:String = "Gautam"
    let otherId:String = "Khushee"
    
    @State private var selectedId: String = "Gautam"
    @State private var addTransactionSheet = false
    @State private var payBillSheet = false
    @State private var isLoading: Bool = false
    @State private var showDeleteAlert:TransactionModel?
    @State private var selectedSection = true
    @State private var searchText = ""
    @State private var sortParam:String = "Newest"
    @State private var isDesc: Bool = true
    @State private var onlyMyTransactions: Bool = false
    @ObservedObject var viewModel = FirebaseServices();
    @AppStorage("isDarkMode") private var isDarkTheme = false
    @State private var sortOptions = ["Newest", "Oldest", "Highest Amount", "Lowest Amount"]
    
    var body: some View {
        if(isLoading){
            ProgressView()
        }
        NavigationView {
            VStack{
                HStack{
                    Text("Overview")
                        .fontWeight(.bold)
                    Spacer()
                    Toggle(isOn: $isDarkTheme){}
                        .onChange(of: isDarkTheme) {
                            _isOn in
                            downloadData()
                        }
                }
                VStack{
                    Text("Balance")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.6))
                    Text("\(rupeeSign)\(viewModel.totalBalance)")
                        .fontWeight(.bold)
                        .font(.largeTitle)
//                    Picker("Selected section:", selection:Binding(get: {
//                        myId == selectedId
//                    }, set: {newVal in
//                        selectedId = newVal ? myId : otherId
//                        downloadData()
//                    })) {
//                        Group {
//                            Text(myId)
//                                .tag(true)
//                            Text(otherId)
//                                .tag(false)
//                        }
//                    }
//                    .padding()
//                    .pickerStyle(SegmentedPickerStyle())
                    
                    Toggle("Only my transactions",isOn: $onlyMyTransactions )
                        .onChange(of: onlyMyTransactions) {
                            _isOn in
                            downloadData()
                        }
                }
                .frame(height: 120)
                Picker("Sort", selection: $sortParam) {
                    ForEach(sortOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: sortParam){
                    newVal in
                    downloadData()
                }
                Divider()
                NavigationLink(destination:  Notes()
                ){
                    Text("View Notes")
                        .frame(maxWidth: .infinity)
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                Text("Transaction History (\(viewModel.transactions.count))")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if(viewModel.transactions.isEmpty){
                    VStack(alignment: .center){
                        Spacer()
                        Image(systemName: "clock").foregroundColor(.gray)
                            .font(.largeTitle)
                        Spacer().frame(height: 10)
                        Text("No transactions found")
                        Spacer()
                    }
                    .padding()
                }
                else{
                    List{
                        ForEach(viewModel.transactions,  id: \.self.hashValue){ transaction in
                            TransactionTile(selectedId: selectedId, transaction: transaction)
                                .alert("Delete transaction?", isPresented: Binding(get: {showDeleteAlert != nil}, set: {newVal in
                                    print(newVal)
                                })) {
                                    Button("Yes") {
                                        Task{
                                            if(showDeleteAlert != nil){
                                                await FirebaseServices().deleteTransaction(model: showDeleteAlert!)}
                                            showDeleteAlert = nil
                                            downloadData()
                                        }
                                        
                                    }
                                    Button("No") { showDeleteAlert = nil }
                                }
                                .deleteDisabled(selectedId != transaction.name)
                            
                        }
                        .onDelete{(indexPath) in
                            print(indexPath.first!)
                            showDeleteAlert = viewModel.transactions[indexPath.first!]
                        }
                    }
//                    .frame(height: 400)
                    .refreshable {
                        downloadData()
                    }
                    //                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic)) {}
                }
                Spacer()
             

                GeometryReader {
                    gp in
                    HStack{
                        Button(action: {
                            addTransactionSheet.toggle()
                        }){
                            Text("Add Transaction")
                                .frame(width: gp.size.width * 0.4)
                                .lineLimit(1)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        .sheet(isPresented: $addTransactionSheet, onDismiss: {
                            Task{
                                downloadData()
                            }
                            
                        }) {
                            AddTransactionView(myId: selectedId, otherId:selectedId == otherId ? myId : otherId)}
                        Spacer()
                        Button(action: {
                            payBillSheet.toggle()
                        }){
                            Text("Pay Bill")
                                .frame(width: gp.size.width*0.4)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .sheet(isPresented: $payBillSheet, onDismiss: {
                            Task{
                                downloadData()
                            }
                            
                        }) {
                            PayBillView(myId: myId, otherId: otherId)}
                    }
                    
                }
                .frame(height: 0)
                .padding()
            } .padding()
            
        }
        .task {
            downloadData()
        }
        
        //        .preferredColorScheme(isDarkTheme ? .dark : .light)
    }
    
    
    func downloadData() {
        print("Loading data")
        var sortValue:String
        switch (sortParam){
        case "Newest":
            sortValue = "timeStamp"
            isDesc = true
            break;
        case "Oldest":
            sortValue = "timeStamp"
            isDesc = false
        case "Highest Amount":
            sortValue = "amount"
            isDesc = false
        case "Lowest Amount":
            sortValue = "amount"
            isDesc = true
        default:
            sortValue = "timeStamp"
            isDesc = false;
        }
        viewModel.fetchData(myId: selectedId, sortParam: sortValue, desc: isDesc, onlyMyTransactions: onlyMyTransactions);
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TransactionTile: View {
    let selectedId: String
    let transaction: TransactionModel
    
    var body: some View {
        let isMyValue:Bool = selectedId != transaction.name
        
        NavigationLink(destination:  TransactionView(myId: selectedId, transactionModel: transaction)
        )
        {
            HStack{
                Text(transaction.name.uppercased().prefix(1))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(isMyValue ?.purple: .blue)
                    .clipShape(Circle())
                
                VStack(alignment: .leading){   Text("\(transaction.name)")
                        .font(.headline)
                    //    .foregroundColor(.black.opacity(0.6));
                    Text("\(transaction.reason ?? "")")
                        .font(.subheadline)
                    //   .foregroundColor(.black.opacity(0.6))
                }
                .padding(.horizontal, 2)
                Spacer();      Text("\(rupeeSign)\(transaction.amount.convertToPositive())")
                    .font(.headline)
                    .foregroundColor(isMyValue ? Color.green : Color.red)
            }
        }
    }
}
