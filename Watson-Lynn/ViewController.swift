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

class ViewController: UIViewController {
    
    var speechToText: SpeechToText!
    var isStreaming = false
    var accumulator = SpeechRecognitionResultsAccumulator()
    var toneAnalyzer: ToneAnalyzer!
    var personalityInsight: PersonalityInsights!
    
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var analyzeView: UITextView!
    @IBOutlet weak var sentenceAnalyzeView: UITextView!
    @IBOutlet weak var personalityAnalyzeView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        sentenceAnalyzeView.text = "Getting analytics from Watson .. Please wait"
        
        
        
        toneAnalyzer.tone(toneContent: ToneContent.text(textView.text)) { (res, err) in
            if err != nil{
                print(err)
            }else{
                let result = res?.result
                DispatchQueue.main.async {
                    self.analyzeView.text = "Overall Analytics: \n\n\n"
                    self.sentenceAnalyzeView.text = "Sentence Analytics: \n\n\n"
                    
                    result?.documentTone.tones?.forEach({ (tone) in
                        self.analyzeView.text += "\(tone.toneName) with score of \(tone.score.precent)\n"
                    })
                    self.personalityAnalyzeView.text += "\n"
                    
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
