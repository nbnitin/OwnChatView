//
//  MessageModel.swift
//  ChatViewPractise
//
//  Created by Nitin Bhatia on 1/14/21.
//

import Foundation

enum MessageType : String {
    case Text
    case Photo
}

struct MessageModel {
    let messageId : String
    let messageText : String
    let type : MessageType
    let isSent : Bool
    let date : String
    
    static func createMessage(messageText:String,messageType:MessageType,isSent:Bool,date:String)->MessageModel {
        return MessageModel(messageId: UUID().uuidString, messageText: messageText, type: messageType, isSent: isSent,date:date)
    }
    
    static func getMessageDate(date:Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" //:SS zzzz
        dateFormatter.locale = Locale(identifier: "en-US")
        return dateFormatter.string(from: date)
    }
}
