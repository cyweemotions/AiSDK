//
//  AiSupport.swift
//  AiCoache
//
//  Created by cywee on 2024/12/2.
//

import UIKit
import Alamofire
import SwiftyJSON
import CommonCrypto


// 自定义拦截器
public class AiRequestInterceptor: RequestInterceptor {
    private let retries: Int
    init(retries: Int = 3) {
        self.retries = retries
    }
    
    // 请求重试策略
    public func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    // 请求重试机制
    public func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        if request.retryCount < retries {
            completion(.retry)
        } else {
            completion(.doNotRetry)
        }
    }
}
// 自定义日志监控器
public class NetworkLogger: EventMonitor {
    public let queue = DispatchQueue(label: "com.networklogger")
    
    // 打印请求信息
    public func requestDidStart(_ request: Request) {
        debugPrint("Request started: \(request)")
    }
    
    // 打印响应信息
    public func requestDidFinish(_ request: Request) {
        debugPrint("Request finished: \(request)")
    }
    
    // 打印请求/响应体
    public func request(_ request: Request, didParseResponse response: DataResponse<Data?, AFError>) {
        switch response.result {
        case .success(let data):
            debugPrint("Response data: \(String(describing: data))")
        case .failure(let error):
            debugPrint("Request failed with error: \(error)")
        }
    }
}

enum HTTPError: Error {
    case requestFailed
    case invalidResponse
    case unknown
}

// 封装网络请求工具类
public class AiHttpSupport {
    
    
    static let shared = AiHttpSupport()
    static let appSecret:String = "&appSecret=KGd1psWczjsGZoBrSjt8vapnEtTNQMxO"
    
    private var session: Session

    init() {
        // 配置 URLSessionConfiguration，设置超时等
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // 设置请求超时时间 30秒
        configuration.timeoutIntervalForResource = 30 // 设置资源超时时间 30秒
        
        // 创建自定义拦截器
        let interceptor = AiRequestInterceptor(retries: 3)
        
        // 创建会话，指定配置，拦截器，和日志监控
        self.session = Session(
            configuration: configuration,
            interceptor: interceptor,
            eventMonitors: [NetworkLogger()]
        )
    }
        
      // 发起 GET 请求 (使用 responseJSON)
      public func get(url: String, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<Any, Error>) -> Void) {
           
           session.request(url, method: method, parameters: parameters, headers: headers)
               .validate()
               .responseJSON { response in
                   switch response.result {
                   case .success(let json):
                       let res = JSON(json)
                        // 判断是否是 200 成功响应
                        if let statusCode = response.response?.statusCode, statusCode == 200 {
                            completion(.success(res))
                        } else {
//                            let error = response.error
//                            completion(.failure(error ?? <#default value#>)) // 其他非 200 状态码失败
                        }
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
       }
       
       // 发起 POST 请求 (使用 responseJSON)
       public func post(url: String, parameters: Parameters, headers: HTTPHeaders? = nil, completion: @escaping (Result<JSON, Error>) -> Void) {
           print("请求数据:\(parameters)---\(String(describing: headers))")
           session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
               .validate()
               .responseJSON { response in
                   switch response.result {
                   case .success(let json):
                       let res = JSON(json)
                        // 判断是否是 200 成功响应
                        if let statusCode = response.response?.statusCode, statusCode == 200 {
                            completion(.success(res))
                        } else {
//                            let error = response.error
//                            completion(.failure(error ?? <#default value#>)) // 其他非 200 状态码失败
                        }
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
       }
    
       ///创建 签名
    public func create(currentTimeMillis:Int,userId:Int) -> String{
        let dictionary: [String: Int] = ["timestamp": currentTimeMillis, "userId": userId]
        var value = JSON(dictionary)
        let sortDict = value.dictionaryObject!
        print("sortDict:\(sortDict)")
        let sortedKeys = sortDict.keys.sorted()
        // 创建一个新的有序字典
        var sortedDict = [String: Any]()
        for key in sortedKeys {
            sortedDict[key] = sortDict[key]
        }
        // 将有序字典转换回 JSON 对象
        let sortedJSON = JSON(sortedDict)
        // 将数组转换为JSON数据
        print("sortedJSON:\(sortedJSON)")
        let dict = sortedJSON.dictionaryObject
        print("queryParams:\(dict?.queryParameters)")
        // 将字典转换为 URL 编码后的查询参数字符串
        let queryParams = (dict?.queryParameters ?? "") + AiHttpSupport.appSecret

        let signature = MD5ForLower32Bate(value: queryParams)
        print("signature:\(signature)")
        return signature
    }
    
    
    ///MD5加密32位小写
    public func MD5ForLower32Bate(value:String) -> String {
           let str = value.cString(using: .utf8)
           let strLen = CUnsignedInt(value.lengthOfBytes(using: .utf8))
           let digestLen = Int(CC_MD5_DIGEST_LENGTH)
           let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
           CC_MD5(str!, strLen, result)
           let hash = NSMutableString.init()
           for i in 0..<digestLen {
               hash.appendFormat("%02x", result[i])
           }
           result.deinitialize(count: digestLen)
           return String(hash)
    }

    
}


// 扩展 Dictionary 来添加一个计算属性来创建 URL 编码的查询参数字符串
extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    var queryParameters: String? {
        // 将字典转换为字符串数组
        let queryParameters = self.map { (key, value) -> String in
            if let stringValue = String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return "\(key)=\(stringValue)"
            }
            return ""
        }
        .joined(separator: "&")
        
        // 如果有内容，返回带有前缀 "?" 的字符串，否则返回 nil
        return queryParameters.isEmpty ? nil : "?\(queryParameters)"
    }
}


