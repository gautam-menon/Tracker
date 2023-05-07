//
//  PayBillView.swift
//  Finance_example
//
//  Created by Gautam on 14/12/22.
//

import SwiftUI

struct PayBillView: View {
    let myId:String
    let otherId:String
    
    @State var selectedId:String  = TransactionModel.selectedId
    
    @State var amount = ""
    @State var reason = ""
    @State var isLoading = false;
    @State var alertMessage = "";
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        if(isLoading){
            ProgressView()
        }
        else
        {
            VStack(alignment: .center){
                HStack(){
                    Text("Pay Bill")
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
                Text("Who's Paying?")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Button(action: {
                        selectedId = myId
                    }){
                        PersonTile(color:.blue ,name: myId, isSelected: myId == selectedId)
                    }
                    Button(action:{
                        selectedId = otherId
                    } ){
                        PersonTile(color:.purple,name: otherId, isSelected: otherId == selectedId)
                    }
                }
                
                .padding()
                HStack {
                    TextField("Amount in \(rupeeSign)", text: $amount)
                        .multilineTextAlignment(.center)
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
                if(Int(amount) != nil){
                    let text = selectedId == myId ? "\(otherId) Owes You: " : "You Owe \(otherId): "
                    Text("\(text)\(rupeeSign)\(Int(amount)!/2)")
                        .font(.title2)
                }
                
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
            var finalAmount = Int(amount) ?? 0
            finalAmount.negate()
            let timeStamp:Double = Date()
                .timeIntervalSince1970
            let model = TransactionModel(amount: finalAmount/2, timeStamp: timeStamp, name: selectedId == myId ? otherId  : myId, reason: reason)
            await FirebaseServices().uploadTransaction(model: model)
            presentationMode.wrappedValue.dismiss()
        }
        isLoading = false;
    }
}

struct PayBillView_Previews: PreviewProvider {
    static var previews: some View {
        PayBillView(myId: "Gautam", otherId: "Other")
    }
}
