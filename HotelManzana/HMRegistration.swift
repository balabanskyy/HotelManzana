//
//  Registration.swift
//  HotelManzana
//
//  Created by Artur Balabanskyy on 1/2/18.
//  Copyright © 2018 Artur Balabanskyy. All rights reserved.
//

import Foundation

struct HMRegistration {
    var firstName: String
    var lastName: String
    var email: String
    
    var checkInDate: Date
    var checkOutDate: Date
    
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var wifi: Bool
    var roomType: HMRoomType
}
