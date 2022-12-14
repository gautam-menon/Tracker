//
//  AddTransactionView.swift
//  Finance_example
//
//  Created by Gautam on 29/11/22.
//

import SwiftUI

struct AddTransactionView: View {
    let name:String
    @Environment(\.presentationMode) var presentationMode
    
    @State var amount = ""
    @State var reason = ""
    @State var isLoading = false;
    @State var alertMessage = "";
    var body: some View {
        if(isLoading){
            ProgressView()
        }
        else
        {
            VStack(alignment: .center){
                HStack(){
                    Text("Add a transaction")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action:  {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Cancel")
                    }
                }
                Spacer()
                    .frame(height: 50)
                VStack{
                    Text(name.prefix(1))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)
                        .clipShape(Circle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(name)
                        .fontWeight(.bold)
                }
                .padding()
                HStack {
                    TextField("Amount in \(rupeeSign)", text: $amount)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .frame(width: 130, alignment: .center)
                        .keyboardType(.numberPad)
                }
                Spacer()
                    .frame(height: 20)
                TextField("Reason (Optional)", text: $reason)
                    .padding()
                    .border(.blue)
                //                    .padding(20)
                //                    .overlay(
                //                        RoundedRectangle(cornerRadius: 14)
                //                            .stroke(Color.blue, lineWidth: 1)
                //                    )
                Spacer()
                Button(action: onClick){
                    HStack {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                        Text("Add transaction")
                    }
                    .foregroundColor(.white)
                    .frame(width: 200, height: 40)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding()
                }.frame(maxWidth: .infinity, alignment: .center)
                
                    .alert("\(alertMessage)", isPresented: Binding(get: {!alertMessage.isEmpty}, set: {
                        newValue in
                        self.alertMessage = ""
                    })) {
                        Button("OK", role: .cancel) { }
                    }
            }.padding()}
    }
    
    func onClick()
    {
        Task {
            
            if(amount.isEmpty){
                alertMessage = "No amount entered"
                return;
            }
            isLoading = true;
            let timeStamp = Date().formatted(date: .abbreviated, time: .shortened)
            let model = TransactionModel(amount: Int(amount) ?? 0, timeStamp: timeStamp, name: name, reason: reason)
            await FirebaseServices().uploadTransaction(model: model)
            presentationMode.wrappedValue.dismiss()
            
        }
        isLoading = false;
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(name: "Gautam")
    }
}
