// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

//注意不同module访问需要将访问权限设为pubilc
public struct FoodItem {
    public var title = "FoodItem"
    public init(){}
    public func test(){
        print("这是一个sdk的打印")
    }
}
