//
//  Speaker.swift
//  GeniusMachine
//
//  Created by Andrei Pachtarou on 25.06.22.
//  Copyright © 2022 Sun*. All rights reserved.
//

import AVFoundation

class Speaker {
    let synthesizer: AVSpeechSynthesizer

    init () {
        synthesizer = AVSpeechSynthesizer()
    }

    func speak(_ msg: String) async {
        return await withCheckedContinuation { [weak self] continuation in
            guard let self = self else {
                continuation.resume()
                return
            }

            var speechHandler: SpeechHandler?
            speechHandler = .init(finish: {
                continuation.resume()
                speechHandler = nil
            })

            synthesizer.delegate = speechHandler

            let utterance = AVSpeechUtterance(string: msg)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5

            self.synthesizer.speak(utterance)
        }
    }
}

extension Speaker {
    @objc
    class SpeechHandler: NSObject, AVSpeechSynthesizerDelegate {
        var finish: (() -> Void)?
        var start: (() -> Void)?

        init(start: (() -> Void)? = nil, finish: (() -> Void)? = nil) {
            self.start = start
            self.finish = finish
        }

        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
            start?()
        }

        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
            finish?()
        }

        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {

        }

        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {

        }

        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
            finish?()
        }

        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {

        }
    }
}
