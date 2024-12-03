//
//  AiRequest.swift
//  AiCoache
//
//  Created by cywee on 2024/12/2.
//

import UIKit

class AiRequest: NSObject {
    var userId:Int32 = 0
    var birthday:String = ""
    var courseType:Int = 0
    var height:Int = 170
    var monthlyDistanceType:Int = 0
    var sex:Int = 0
    var startTime:String = ""
    var trainingDaysPerWeek:String = ""
    var weight:Int = 50
    
}
class loginModel:NSObject{
    var appkey:String = "" //appKey
    var sex:Int = 0 //用户性别(0-男 1-女）
    var userAccount:String = "" //用户帐号
    var userName:String = "" //用户名称
    var userPassword:String = ""//用户密码
}
