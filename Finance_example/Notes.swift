//
//  Notes.swift
//  Finance_example
//
//  Created by Gautam on 06/02/23.
//

import SwiftUI

struct Notes: View {
    @ObservedObject var viewModel = FirebaseServices()
    
    var body: some View {
//        NavigationView{
            VStack{
                if(viewModel.notes.isEmpty){
                    Spacer()
                    Text("No Notes")
                        .bold()
                    Spacer()
                    
                }
                else{
                    List{
                        ForEach(viewModel.notes, id: \.self.hashValue){
                            val in
                            NavigationLink(destination:  CreateNote(note: val)
                            ){
                                Text(val.title.isEmpty ? val.body : val.title)
                            }
                            
                        }
                    }
                    .refreshable {
                        
                            downloadData()
                        
                    }
                }
                HStack{
                    Text("\(viewModel.notes.count) Notes")
                    Spacer()
                    NavigationLink(destination:  CreateNote()){
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                }
                
                
                
            }
            .padding()
            .task {
                downloadData()
            }
//        }
        .navigationTitle("Notes")
        
    }
    func downloadData(){
        viewModel.getNotes(sortString: "timeStamp")
    }
}

struct Notes_Previews: PreviewProvider {
    static var previews: some View {
        Notes()
    }
}
