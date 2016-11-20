//: Playground - noun: a place where people can play

import UIKit


func matchesForRegexInText(regex: String!, text: String!) -> String {
    do {
        let regex = try NSRegularExpression(pattern: regex, options: [])
        let nsString = text as NSString
        let results = regex.matchesInString(text,
            options: [], range: NSMakeRange(0, nsString.length))
        
        let val = results.map { nsString.substringWithRange($0.range)}
        
        if val.count == 0 {
            return ""
        } else {
            return val[0]
        }
        
    } catch let error as NSError {
        print("invalid regex: \(error.localizedDescription)")
        return ""
    }
}

struct Mms {

    var header = "test"
    var money = ""
    var type = ""
    var card = ""
    var bank = ""
    var user_name = ""
    var date = ""
    
}

func parse(sms:String) ->  Mms {
    
    var parsedMms = Mms()
    
    parsedMms.header = matchesForRegexInText("\\bWeb발신\\b", text: sms)
    parsedMms.money = matchesForRegexInText("[\\d,\\-]+원", text: sms)
    parsedMms.card = matchesForRegexInText("\\S+카드", text: sms)
//    parsedMms.user_name = = matchesForRegexInText("\\S+카드", text: sms)
    parsedMms.date = matchesForRegexInText("\\d\\d/\\d\\d", text: sms)

    let cleanArray = parsedMms.money.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) as NSArray
    let cleanCentString  = cleanArray.componentsJoinedByString("")
    
    parsedMms.money = cleanCentString
    
    return parsedMms
}

//func parse(sms:String) {
//    
//    let test = matchesForRegexInText("\\bWeb발신\\b", text: sms)
//    let test1 = matchesForRegexInText("[\\d,\\-]+원", text: sms)
//    let test2 = matchesForRegexInText("\\d\\d/\\d\\d", text: sms)
//    let test3 = matchesForRegexInText("\\d\\d:\\d\\d", text: sms)
//
//    
//}

var pasteBoardString = UIPasteboard.generalPasteboard().string

print("pastboard \(pasteBoardString)")
let sms = "[Web발신]\nKB국민체크(1*4*)\n박*성님\n10/22 08:53\n2,480원\n지에스25엔씨소 사용\n"
let sms1 = "[Web발신]\n신한카드승인 박*성(1*1*) 10/23 13:49 (일시불)201,000원 다나음마취통 누적2,460,060원"
let sms2 = "[Web발신]\n[MY COMPANY]-승인\n0508\n박준성님\n10/22 19:58\n150,000원(일시불)\n한미비자지원"
let sms3 = "[Web발신]\n[일시불.승인]\n201,000원\n기업BC(4*6*)박*성님\n10/01 18:03\n누적201,000원\n다나음마취통증의"

print(parse(sms))
print(parse(sms1))
print(parse(sms2))
print(parse(sms3))
