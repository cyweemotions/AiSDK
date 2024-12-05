// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import Alamofire
import SwiftyJSON


//typealias successCallBack = (String) -> ()
//typealias failedCallBack = (String) -> ()


public class AiSupport{
    let baseUrl = "https://test-health.cyweemotion.cn/cmms"
    let createPlanUrl = "https://test-health.cyweemotion.cn/cmms/external/trainingCourse/generateTrainingPlan"
    let getPlanUrl = "https://test-health.cyweemotion.cn/cmms/external/trainingCourse/getTrainingCourseInfo"
    let stopPlanUrl = "https://test-health.cyweemotion.cn/cmms/external/trainingCourse/stopTrainingPlan"
    let loginUrl = "https://test-health.cyweemotion.cn/cmms/external/userAccountRegister"
    
    
    static let shared = AiSupport()
    
    init(){
        
    }
    
    ///登录
    public func login(param:loginModel,success:(String) -> (),failed:(String) -> ()){
        let json = param.tojson()
        var dict = json.dictionaryObject!
        let currentDate = Int(Date().timeIntervalSince1970 * 1000)
        dict["timestamp"] = String(currentDate)
        print("dict数据:\(dict)")
        // 按键升序排序
        let sortedKeys = dict.keys.sorted()
        var orderedDict = [String: Any]()
        for key in sortedKeys {
            orderedDict[key] = dict[key]
        }
        ///排序
        let absoluteString = dictionaryToOrderedURLParams(dict: dict)
        print("sortedDict数据:\(absoluteString)")

        let queryParams = absoluteString + AiHttpSupport.appSecret
        print("queryParams:\(queryParams)")
        let signature = AiHttpSupport.shared.MD5ForLower32Bate(value: queryParams)
  
        var dynamicHeaders: HTTPHeaders = []
        dynamicHeaders.add(name: "signature", value: signature)
        dynamicHeaders.add(name: "timestamp", value: String(currentDate))
        AiHttpSupport.shared.post(url: loginUrl, parameters: orderedDict, headers: dynamicHeaders) { (result: Result<JSON, Error>) in
            print("登录返回:\(result)")
//            let res:JSON = JSON(rawValue: result) ?? JSON()
//            print(type(of: result))
            
//            if let dict = result.dictionaryObject{
//                print("登录返回w:\(dict))")
//            }

        }
    }
    
   
     

    ///生成计划
    public func createPlan(params:AiRequest,success:(String) -> (),failed:(String) -> ()){
        let json = params.tojson()
        var dict = json.dictionaryObject!
        let currentDate = Int(Date().timeIntervalSince1970 * 1000)
        dict["timestamp"] = String(currentDate)
        print("dict数据:\(dict)")
        // 按键升序排序
        let sortedKeys = dict.keys.sorted()
        var orderedDict = [String: Any]()
        for key in sortedKeys {
            orderedDict[key] = dict[key]
        }
        ///排序
        let absoluteString = dictionaryToOrderedURLParams(dict: dict)
        print("sortedDict数据:\(absoluteString)")

        let queryParams = absoluteString + AiHttpSupport.appSecret
        print("queryParams:\(queryParams)")
        let signature = AiHttpSupport.shared.MD5ForLower32Bate(value: queryParams)
  
        var dynamicHeaders: HTTPHeaders = []
        dynamicHeaders.add(name: "signature", value: signature)
        dynamicHeaders.add(name: "timestamp", value: String(currentDate))
        AiHttpSupport.shared.post(url: createPlanUrl, parameters: orderedDict, headers: dynamicHeaders) { (result: Result<JSON, Error>) in
            print("创建返回w:\(result))")

        }
    }
    
    ///获取计划
    public func getPlan(userId:String,success:(String) -> (),failed:(String) -> ()){
        let currentDate = Int(Date().timeIntervalSince1970 * 1000)
        
        var dynamicHeaders: HTTPHeaders = []
        dynamicHeaders.add(name: "signature", value: signture(currentDate: currentDate, userId: userId))
        dynamicHeaders.add(name: "timestamp", value: String(currentDate))
        let URL = getPlanUrl + "?userId=\(userId)"
        print("url:\(URL)")
        AiHttpSupport.shared.get(url: URL,headers:dynamicHeaders) { res in
            print("计划获取:\(res)")
        }
    }
    
    ///停止计划
    public func stopPlan(userId:String,success:(String) -> (),failed:(String) -> ()){
        let currentDate = Int(Date().timeIntervalSince1970 * 1000)
        let URL = stopPlanUrl + "?userId=\(userId)"
        var dynamicHeaders: HTTPHeaders = []
        dynamicHeaders.add(name: "signature", value: signture(currentDate: currentDate, userId: userId))
        dynamicHeaders.add(name: "timestamp", value: String(currentDate))
        var orderedDict = [String: Any]()
        AiHttpSupport.shared.post(url: URL, parameters: orderedDict, headers: dynamicHeaders) { (result: Result<JSON, Error>) in
            print("停止计划:\(result))")

        }
    }
    
    func signture(currentDate:Int,userId: String) -> String{
        var dictionaryObject: [String: String] = [:]
        dictionaryObject["timestamp"] = String(currentDate)
        dictionaryObject["userId"] = String(userId)
        ///排序
        let absoluteString = dictionaryToOrderedURLParams(dict: dictionaryObject)
        print("sortedDict数据:\(absoluteString)")
        let queryParams = absoluteString + AiHttpSupport.appSecret
        print("queryParams:\(queryParams)")
        let signature = AiHttpSupport.shared.MD5ForLower32Bate(value: queryParams)
        return signature
    }
    func dictionaryToOrderedURLParams(dict: [String: Any]) -> String {
        // 排序字典的键
        let sortedKeys = dict.keys.sorted()
        
        // 构建查询字符串
        var queryItems: [String] = []
        
        for key in sortedKeys {
            if let value = dict[key] {
                // 对键和值进行 URL 编码
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "\(value)"
                
                queryItems.append("\(encodedKey)=\(encodedValue)")
            }
        }
        
        // 将各项参数拼接成查询字符串
        return queryItems.joined(separator: "&")
    }
    
}
//注意不同module访问需要将访问权限设为pubilc
public struct FoodItem {
    public var title = "FoodItem"
    public var appKey : String = "XXDZyRfXVepBLYk4jAZbVGL9FDdLFpfV"
    public init(){}
    public func login(){
        print("这是一个sdk的打印")
        let currentDate = Int(Date().timeIntervalSince1970 * 1000)
        print("currentDate:\(currentDate)")
        let model = loginModel()
        model.appkey = "XXDZyRfXVepBLYk4jAZbVGL9FDdLFpfV"
        model.sex = 0
        model.userAccount = "Test123456"
        model.userName = "Test"
        model.userPassword = "123456"
        AiSupport.shared.login(param: model) { response in
            
        } failed: { error in
            
        }
        
        
    }
    
    public func create(){
        let model = AiRequest()
        model.userId = "9342488142848"
        model.birthday = "2000-11-11"
        model.courseType = 1
        model.height = 170
        model.monthlyDistanceType = 1
        model.sex = 0
        model.startTime = "2024-12-05"
        model.trainingDaysPerWeek = "1,3,5"
        model.weight = 50
        AiSupport.shared.createPlan(params: model) { res in
            
        } failed: { error in
            
        }
    }
    
    public func stoplan(){
        
        AiSupport.shared.stopPlan(userId: "9342488142848") { res in
            
        } failed: { error in
            
        }

        
    }
    
    public func getPlan(){
        AiSupport.shared.getPlan(userId: "9342488142848") { res in
            
        } failed: { error in
            
        }

    }
    
     

}
