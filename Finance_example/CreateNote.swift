//
//  CreateNote.swift
//  Finance_example
//
//  Created by Gautam on 06/02/23.
//

import SwiftUI

struct CreateNote: View {
    var note:NotesModel?
    @State private var title = ""
    @State private var text = ""
    @FocusState private var keyboardFocused:Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            TextField(text: $title, label:{
                Text("Title")
                    .font(.title)
            }
            )
            .font(.title)
            
                .padding()
            Divider()
            TextEditor(text: $text)
                .padding()
                .focused($keyboardFocused)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if(note?.title != nil){
                            title = note!.title
                        }
                        if(note?.body != nil){
                            text = note!.body
                        }
                        keyboardFocused = true
                    }
                }
                .navigationTitle("Create Note")
                .toolbar {
                    Button("Done") {
                        keyboardFocused = false
                        func onSubmit(text:String){
                            Task{
                                if(!text.isEmpty){
                                    var model:NotesModel
                                    let timeStamp:Double = Date().timeIntervalSince1970
                                    if(note == nil){
                                        //Create Note
                                         model = NotesModel(title: title, body: text, timeStamp: timeStamp, ownerUid: TransactionModel.selectedId)
                                    }else{
                                        //Update Note
                                         model = NotesModel(title: title, body: text, timeStamp: timeStamp, ownerUid: note!.ownerUid, documentId: note!.documentId)
                                     
                                    }
                                    await FirebaseServices().addNoteToDB(model: model)
                                    dismiss()
                                }
                        }
                    }
                    onSubmit(text: text)
                }
            }
        }
}


struct CreateNote_Previews: PreviewProvider {
    static var previews: some View {
        CreateNote(note: NotesModel(title: "Note 1", body: "Hello HI", timeStamp: 12345678, ownerUid: "Gautam"))
    }
}
}
