//
//  NotesModel.swift
//  Finance_example
//
//  Created by Gautam on 06/02/23.
//

import Foundation

struct NotesModel:Hashable, Codable{
    let title:String
    let body:String
    let timeStamp:Double
    let ownerUid:String
    var documentId:String?
    
}
