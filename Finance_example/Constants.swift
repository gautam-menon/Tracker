//
//  constants.swift
//  Finance_example
//
//  Created by Gautam on 29/11/22.
//

import Foundation

let rupeeSign = "₹"
let commaSymbol = ","

extension Int{
    func commaFunction ()-> String {
        let formatString = "\(self)".trimmingCharacters(in: .whitespaces)
        if(formatString.count>3)
        {
            let finalString = "\(formatString.prefix(3)) + \(commaSymbol) + \(formatString.suffix(3))"
            return finalString
        }
        else{
            return formatString
        }
    }
}

extension String?{
    func isTrulyNotEmpty ()-> Bool {
        if(self == nil){
            return false;
        }
        else
        {
            let formattedString = self!.trimmingCharacters(in: .whitespaces)
            return !formattedString.isEmpty
            
        }
    }
    
   func okay() -> String{
        if(self.isTrulyNotEmpty()){
            return self!.prefix(0).description
        }
        else{
            return self ?? ""
        }
        
    }
    
}
