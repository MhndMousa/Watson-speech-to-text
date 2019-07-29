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
    @IBOutlet weak var isRecordingLabel: UILabel!
    //    @IBOutlet weak var analyzeButton: UIButton!
//    @IBOutlet weak var personalityButton: UIButton!
    //    @IBOutlet weak var analyzeView: UITextView!
//    @IBOutlet weak var sentenceAnalyzeView: UITextView!
//    @IBOutlet weak var personalityAnalyzeView: UITextView!
//    @IBOutlet weak var tableView: UITableView!
    
    var coloredTone = [SentenceAnalysis]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        self.tableView.dataSource = self
//        self.tableView.delegate = self
//        tableView.separatorStyle = .none
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 600
        
        
        
        speechToText = SpeechToText(apiKey: "sQlt7zBj8ablPIyH7ExjrVETGTBjhpOibFCCNr01imF-")
        toneAnalyzer = ToneAnalyzer(version: "2017-09-21", apiKey: "uJyDOwI9DHO2orh0nFXJPxKeTYjJlrekK5DKf1lPMVrl")
        personalityInsight = PersonalityInsights(version: "2017-10-13", apiKey: "XflUV2fhbXd9hdlaa7foDV2GJx4Wze0uDJPCc5WRkWQq")
        
        
        microphoneButton.layer.cornerRadius = microphoneButton.bounds.width/2
        microphoneButton.backgroundColor = .white
        
        
        microphoneButton.layer.shadowColor = UIColor.black.cgColor
        microphoneButton.layer.shadowOpacity = 0.3
        microphoneButton.layer.shadowOffset = .zero
        microphoneButton.layer.shadowRadius = 3
        
        
        let a = CurvedView(frame: CGRect(x: 0, y: view.bounds.height - 220, width: view.bounds.width, height: 220))
        let b = CurvedViewWithAlpha(frame: CGRect(x: view.bounds.width/2, y: view.bounds.height - 250, width: view.bounds.width, height: 250))
        let c = CurvedViewWithAlpha(frame: CGRect(x: -view.bounds.width/2, y: view.bounds.height - 250, width: view.bounds.width, height: 250))
        
        a.backgroundColor = .clear
        b.backgroundColor = .clear
        c.backgroundColor = .clear
        
        a.colorIt(c: .green)
//        let a = CurvedView(frame: <#T##CGRect#>)
//        a.frame = CGRect(x: 0, y: view.bounds.height - 250, width: view.bounds.width, height: 250)
//        a.draw(a.frame, color: .green)
        
//        let a = CurvedView()
//        a.draw(CGRect(x: 0, y: view.bounds.height - 250, width: view.bounds.width, height: 250), color: .green)
        
        
        
        view.insertSubview(a, belowSubview: isRecordingLabel)
        view.insertSubview(b, aboveSubview: a)
        view.insertSubview(c, aboveSubview: a)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
//    
//    @IBAction func personalityButtonClicked(_ sender: Any) {
//        performSegue(withIdentifier: "toPersonalityVC", sender: nil)
//    }
//    
//    @IBAction func analyzeButtonClicked(_ sender: Any) {
//        performSegue(withIdentifier: "toAnalyzeVC", sender: nil)
//    }
//    
    @IBAction func recordButtonClicked(_ sender: Any) {
        if !isStreaming {
            isStreaming = true
//            microphoneButton.setTitle("Stop Microphone", for: .normal)
            var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
            settings.interimResults = true
            var callback = RecognizeCallback()
            callback.onError = { error in
                print(error)
            }
            callback.onResults = { results in
                
                self.isRecordingLabel.text = "Recording"
                self.isRecordingLabel.textColor = .darkRed
                self.microphoneButton.titleLabel?.textColor = .darkRed
                self.accumulator.add(results: results)
                print(self.accumulator.bestTranscript)
                self.textView.text = self.accumulator.bestTranscript
            }
            
            speechToText.recognizeMicrophone(settings: settings, callback: callback)
        } else {
            isStreaming = false
            
            isRecordingLabel.text = "Not Recording"
            isRecordingLabel.textColor = .gray
            microphoneButton.titleLabel?.textColor = .white
//            microphoneButton.setTitle("Start Microphone", for: .normal)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
//        if segue.destination is SentenceViewController
//        {
//            let vc = segue.destination as? SentenceViewController
//            vc?.words = textView.text
//        }
//        if segue.destination is PersonalityViewController{
//            let vc = segue.destination as? PersonalityViewController
//            vc?.text = textView.text
//        }
    }

    
}


extension ToneScore{
    
    var feelingColor: UIColor {
        switch self.toneName {
        case "Anger":
            return .darkRed
        case "Fear":
            return .darkGreen
        case "Joy":
            return .darkYellow
        case "Sadness":
            return .darkBrown
        case "Analytical":
            return .darkPurple
        case "Confident":
            return .darkBlue
        case "Tentative":
            return .darkOrange
        default:
         return .black
        }
    }
    
}


extension UIColor{

    
    
    class var darkRed: UIColor{return UIColor(netHex: 0x6e1b1b)}
    class var darkGreen: UIColor{return UIColor(netHex: 0x2c6e1b)}
    class var darkYellow: UIColor{return UIColor(netHex: 0xc4b65a)}
    class var darkBrown: UIColor{return UIColor(netHex: 0x8a6030)}
    class var darkPurple: UIColor{return UIColor(netHex: 0x75308a)}
    class var darkBlue: UIColor{return UIColor(netHex: 0x18ad81)}
    class var darkOrange: UIColor{return UIColor(netHex: 0xD18B0A)}
    
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
