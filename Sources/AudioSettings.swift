//
//  AudioSettings.swift
//  SCNRecorder
//
//  Created by Vladislav Grigoryev on 15.09.2020.
//  Copyright © 2020 GORA Studio. https://gora.studio
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import AVFoundation

public struct AudioSettings {
    
    static let defaultSampleRate = 44100.0
    
    static let defaultNumberOfChannels = 1
    
    public var format = kAudioFormatMPEG4AAC
    
    public var sampleRate = defaultSampleRate
    
    public var numberOfChannels = defaultNumberOfChannels
}

extension AudioSettings {
    
    public init(audioFormat: AVAudioFormat) {
        sampleRate = audioFormat.sampleRate
        numberOfChannels = Int(audioFormat.channelCount)
    }
    
    public init(
        desiredSampleRate: Double = 16_000,
        desiredChannels: Int? = nil,
        codec: AudioFormatID = kAudioFormatMPEG4AAC
    ) {
        let resolvedChannels = desiredChannels
        ?? Int(AVAudioSession.sharedInstance().inputNumberOfChannels)
        
        if let avFormat = AVAudioFormat(
            standardFormatWithSampleRate: desiredSampleRate,
            channels: AVAudioChannelCount(resolvedChannels)
        ) {
            print("[AudioSettings] Using requested format ⇒ \(desiredSampleRate) Hz / \(resolvedChannels) ch")
            self.format = codec
            self.sampleRate = avFormat.sampleRate
            self.numberOfChannels = Int(avFormat.channelCount)
        } else {
            print("[AudioSettings] Unsupported format \(desiredSampleRate) Hz / \(resolvedChannels) ch; falling back to defaults \(AudioSettings.defaultSampleRate) Hz / \(AudioSettings.defaultNumberOfChannels) ch")
            self.format = codec
            self.sampleRate = AudioSettings.defaultSampleRate
            self.numberOfChannels = AudioSettings.defaultNumberOfChannels
        }
    }
    
    public var outputSettings: [String: Any] {
        [
            AVFormatIDKey: format,
            AVSampleRateKey: sampleRate,
            AVNumberOfChannelsKey: numberOfChannels
        ]
    }
}
