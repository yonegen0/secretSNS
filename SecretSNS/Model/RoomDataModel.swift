//
//  RoomDataModel.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/01/14.
//

import Foundation

class RoomDataModel {
    
    var roomData = 
        ["恋愛","エンターテインメントと趣味","健康、美容、ファッション","生き方、人間関係","ビジネス、経済、お金","ニュース、政治、国際情勢","おしゃべり、雑談"]
    
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
            roomString = "ビジネス、経済、お金"
        case 5:
            roomString = "ニュース、政治、国際情勢"
        case 6:
            roomString = "おしゃべり、雑談"
        default:
            break
        }
        
    }
    
        
}
