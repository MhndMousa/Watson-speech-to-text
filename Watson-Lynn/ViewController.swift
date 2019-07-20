//
//  ViewController.swift
//  Watson
//
//  Created by Muhannad Alnemer on 7/3/19.
//  Copyright © 2019 Muhannad Alnemer. All rights reserved.
//

import UIKit
import SpeechToText
import ToneAnalyzer
import PersonalityInsights

class ViewController: UIViewController{
    
    var speechToText: SpeechToText!
    var isStreaming = false
    var accumulator = SpeechRecognitionResultsAccumulator()
    var toneAnalyzer: ToneAnalyzer!
    var personalityInsight: PersonalityInsights!
    
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var analyzeView: UITextView!
//    @IBOutlet weak var sentenceAnalyzeView: UITextView!
    @IBOutlet weak var personalityAnalyzeView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var coloredTone = [SentenceAnalysis]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        
        
        speechToText = SpeechToText(apiKey: "sQlt7zBj8ablPIyH7ExjrVETGTBjhpOibFCCNr01imF-")
        toneAnalyzer = ToneAnalyzer(version: "2017-09-21", apiKey: "uJyDOwI9DHO2orh0nFXJPxKeTYjJlrekK5DKf1lPMVrl")
        personalityInsight = PersonalityInsights(version: "2017-10-13", apiKey: "XflUV2fhbXd9hdlaa7foDV2GJx4Wze0uDJPCc5WRkWQq")
    }
    
    
    
    @IBAction func personalityButtonClicked(_ sender: Any) {
        
        self.personalityAnalyzeView.text = "Getting analytics from Watson .. Please wait"

        
        personalityInsight.profile(profileContent: .text(textView.text), contentLanguage: nil, acceptLanguage: nil, rawScores: nil, consumptionPreferences: nil, headers: nil) { (res, err) in
            if err != nil{
                print(err?.failureReason)
            }else{
                let result = res?.result
                
                DispatchQueue.main.async {
                    self.personalityAnalyzeView.text = "Personality Insights:\n\n\n"
                    result?.needs.forEach({ (n) in
                        self.personalityAnalyzeView.text += "\(n.name)   \(n.percentile.precentWithSign)\n"
                    })
                    self.personalityAnalyzeView.text += "\n"
                    
                    result?.personality.forEach({ (p) in
                        self.personalityAnalyzeView.text += "\(p.name) \(p.percentile.precentWithSign)\n"
                        p.children?.forEach({ (c) in
                            self.personalityAnalyzeView.text += "* \(c.name) \(c.percentile.precentWithSign)\n"
                        })
                        self.personalityAnalyzeView.text += "\n"
                    })
                    self.personalityAnalyzeView.text += "\n"

                    result?.values.forEach({ (v) in
                        self.personalityAnalyzeView.text += "\(v.name) \(v.percentile.precentWithSign)\n"
                    })
                
                }
            }
        }
        
    }
    
    @IBAction func analyzeButtonClicked(_ sender: Any) {
        
        
        analyzeView.text = "Getting analytics from Watson .. Please wait"
        
        toneAnalyzer.tone(toneContent: ToneContent.text(textView.text)) { (res, err) in
            if err != nil{
                print(err)
            }else{
                let result = res?.result
                DispatchQueue.main.async {
                    self.analyzeView.text = "Overall Analytics: \n\n\n"

                    // Populate tone
                    result?.documentTone.tones?.forEach({ (tone) in
                        self.analyzeView.text += "\(tone.toneName) with score of \(tone.score.precent)\n"
                    })
                    self.personalityAnalyzeView.text += "\n"
                    
                    
                    // Populate Sentences
                    result?.sentencesTone?.forEach({ (sentence) in
                        print(sentence)
                        self.coloredTone.append(sentence)
                    })
                    self.tableView.reloadData()
//                    self.tableView.layoutIfNeeded()
                }
            }
        
        }
    
    }
    
    @IBAction func recordButtonClicked(_ sender: Any) {
        if !isStreaming {
            isStreaming = true
            microphoneButton.setTitle("Stop Microphone", for: .normal)
            var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
            settings.interimResults = true
            var callback = RecognizeCallback()
            callback.onError = { error in
                print(error)
            }
            callback.onResults = { results in
                self.accumulator.add(results: results)
                print(self.accumulator.bestTranscript)
                self.textView.text = self.accumulator.bestTranscript
            }
            
            speechToText.recognizeMicrophone(settings: settings, callback: callback)
        } else {
            isStreaming = false
            microphoneButton.setTitle("Start Microphone", for: .normal)
            speechToText.stopRecognizeMicrophone()
        }
    }
    


}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coloredTone.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sentence = coloredTone[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = sentence.text
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        
        if sentence.tones == [] {
            cell.backgroundColor = .black
            
        }else{
            cell.backgroundColor = sentence.tones?[0].feelingColor
            print(sentence.tones)
        }
        
        return cell
    }
}


extension ToneScore{
    
    var feelingColor: UIColor {
        switch self.toneName {
        case "Anger":
            return UIColor(netHex: 0x6e1b1b) // dark red
        case "Fear":
            return UIColor(netHex: 0x2c6e1b) // green
        case "Joy":
            return UIColor(netHex: 0xc4b65a) // yellow/gold
        case "Sadness":
            return UIColor(netHex: 0x8a6030) // brown
        case "Analytical":
            return UIColor(netHex: 0x75308a) // purble
        case "Confident":
            return UIColor(netHex: 0x18ad81) // cyan
        case "Tentative":
            return UIColor(netHex: 0xdbba14) // orange
        default:
         return .black
        }
    }
    
}


extension UIColor{

    
    
    class var darkRed: UIColor{return UIColor(netHex: 0x6e1b1b)}
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}



extension Double{
    var roundedToTwoDecimals:String{
        return String(format: "%.2f", self)
    }
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    var precent:Int{
        return Int((self * 100).rounded())
    }
    var precentWithSign:String{
        return  "\(self.precent)%"
    }
}
