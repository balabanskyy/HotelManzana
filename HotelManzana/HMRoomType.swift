//
//  HMRoomType.swift
//  HotelManzana
//
//  Created by Artur Balabanskyy on 1/2/18.
//  Copyright © 2018 Artur Balabanskyy. All rights reserved.
//

import Foundation

struct HMRoomType: Equatable {
    var id: Int
    var name: String
    var shortName: String
    var price: Int
    
    static func ==(lhs: HMRoomType, rhs: HMRoomType) -> Bool {
        return lhs.id == rhs.id
    }
    
    static var all: [HMRoomType] {
        return [HMRoomType(id: 0, name: "Two Queen", shortName: "2Q", price: 179),HMRoomType(id: 1, name: "One King", shortName: "K", price: 209),HMRoomType(id: 2, name: "Penthouse Suit", shortName: "PHS", price: 309)]
    }
}
