//
//  RoomDataModel.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/01/14.
//

import Foundation

class RoomDataModel {
    
    var roomData = 
        ["恋愛","エンターテインメントと趣味","健康、美容、ファッション","生き方、人間関係","ビジネス、経済、お金"]
    
    var roomString = String()
    var roomNumber = Int()
    
    func roomLoadData () {
        
        switch roomNumber {
        case 0:
            roomString = "恋愛"
        case 1:
            roomString = "エンターテインメントと趣味"
        case 2:
            roomString = "健康、美容、ファッション"
        case 3:
            roomString = "生き方、人間関係"
        case 4:
            roomString = "money"
        default:
            break
        }
        
    }
    
    func roomSendData() {
        
        switch  roomString{
        case "恋愛":
            roomString = "love"
        case "エンターテインメントと趣味":
            roomString = "hobby"
        case "健康、美容、ファッション":
            roomString = "health"
        case "生き方、人間関係":
            roomString = "communication"
        case "ビジネス、経済、お金":
            roomString = "money"
        default:
            break
        }
    }
}
