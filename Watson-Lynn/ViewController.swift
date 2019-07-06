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

class ViewController: UIViewController {
    
    var speechToText: SpeechToText!
    var isStreaming = false
    var accumulator = SpeechRecognitionResultsAccumulator()
    var toneAnalyzer: ToneAnalyzer!
    
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var analyzeView: UITextView!
    @IBOutlet weak var sentenceAnalyzeView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechToText = SpeechToText(apiKey: "sQlt7zBj8ablPIyH7ExjrVETGTBjhpOibFCCNr01imF-")
        toneAnalyzer = ToneAnalyzer(version: "2017-09-21", apiKey: "uJyDOwI9DHO2orh0nFXJPxKeTYjJlrekK5DKf1lPMVrl")
    }
    
    @IBAction func analyzeButtonClicked(_ sender: Any) {
        
        
        analyzeView.text = "Getting analytics from Watson .. Please wait"
        sentenceAnalyzeView.text = "Getting analytics from Watson .. Please wait"
        
        
        
        toneAnalyzer.tone(toneContent: ToneContent.text(textView.text)) { (res, err) in
            if err != nil{
                print(err)
            }else{
                let result = res?.result

//                print(res?.headers)
//                print( res?.result?.documentTone.tones)
                DispatchQueue.main.async {
                    self.analyzeView.text = "Overall Analytics: \n\n\n"
                    self.sentenceAnalyzeView.text = "Sentence Analytics: \n\n\n"
                    
                    result?.documentTone.tones?.forEach({ (tone) in
                        self.analyzeView.text += "\(tone.toneName) with score of \(tone.score.precent)\n"
                    })
                    
                    result?.sentencesTone?.forEach({ (sentence) in
                        self.sentenceAnalyzeView.text += "\(sentence.text)\n"
                        print(sentence.text)
                        sentence.tones?.forEach({ (tone) in
                            self.sentenceAnalyzeView.text += "Tone: \(tone.toneName) with score of \(tone.score.precent)\n"
                        })
                        self.sentenceAnalyzeView.text += "\n"
                    })
                }
               
                
                
                
            }
        }
        
        
//        guard let url = URL(string: "https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone?version=2017-09-21"),
//            let payload = "{\"text\": \(textView.text)}".data(using: .utf8) else
//        {
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
////        request.
//
//
//        request.httpBody = textView.text.data(using: .utf8)
//        request.addValue("uJyDOwI9DHO2orh0nFXJPxKeTYjJlrekK5DKf1lPMVrl", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = payload
//
//
//            print(request.allHTTPHeaderFields)
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard error == nil else { print(error!.localizedDescription); return }
//            guard let data = data else { print("Empty data"); return }
//
//            if let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
//            }.resume()

        
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
