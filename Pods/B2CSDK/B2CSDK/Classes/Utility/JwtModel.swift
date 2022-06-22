//
//  JwtModel.swift
//  B2CSDK
//
//  Created by Raj Kadam on 10/06/22.
//

import Foundation
import ObjectMapper

struct JWTModel: Mappable {
    var token: String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        token <- map["token"]
    }
    
    
}
