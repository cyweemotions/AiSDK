//
//  AiResponse.swift
//  AiCoache
//
//  Created by cywee on 2024/12/2.
//

import UIKit

class AiResponse: NSObject {
    var courseType:Int = 0
    var endTime:String = ""
    var id:Int32 = 0
    var startTime:String = ""
    var trainingCourseDetailList:Array<TrainingCourseDetail> = []

}

class TrainingCourseDetail:NSObject {
        var courseContent: String = ""
        var courseMins: Int = 0
        var courseName: String = ""
        var courseTime: String = ""
        var id: Int32 = 0
}
