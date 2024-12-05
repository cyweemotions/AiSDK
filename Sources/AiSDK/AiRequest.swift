//
//  AiRequest.swift
//  AiCoache
//
//  Created by cywee on 2024/12/2.
//

import UIKit
import SwiftyJSON

public class AiRequest: NSObject {
    var userId:String = ""
    var birthday:String = ""
    var courseType:Int = 0
    var height:Int = 170
    var monthlyDistanceType:Int = 0
    var sex:Int = 0
    var startTime:String = ""
    var trainingDaysPerWeek:String = ""
    var weight:Int = 50
    
    func tojson() -> JSON{
        // 使用SwiftyJSON将Person转换为JSON
        let json = JSON(["userId": self.userId,
                         "birthday": self.birthday,
                         "courseType": self.courseType,
                         "height": self.height,
                         "monthlyDistanceType": self.monthlyDistanceType,
                         "sex": self.sex,
                         "startTime": self.startTime,
                         "trainingDaysPerWeek": self.trainingDaysPerWeek,
                         "weight": self.weight])
        return json
    }
    
}
public class loginModel:NSObject{
    var appkey:String = "" //appKey
    var sex:Int = 0 //用户性别(0-男 1-女）
    var userAccount:String = "" //用户帐号
    var userName:String = "" //用户名称
    var userPassword:String = ""//用户密码
    
    func tojson() -> JSON{
        // 使用SwiftyJSON将Person转换为JSON
        let json = JSON(["appkey": self.appkey, "sex": String(self.sex), "userAccount": self.userAccount, "userName": self.userName, "userPassword": self.userPassword])
        return json
    }
}
