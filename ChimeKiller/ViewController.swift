//
//  ViewController.swift
//  ChimeKiller
//
//  Created by Adam Hartley on 24/11/2016.
//  Copyright © 2016 BytesGuy. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var chimeStatus: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    
        readChimeStatus()
        
        let alert = NSAlert()
        alert.addButton(withTitle: "Agree")
        alert.addButton(withTitle: "Disagree")
        alert.messageText = "Hey, Listen!"
        alert.informativeText = "Although extremely unlikely, by using this app you acknowledge that I (BytesGuy) cannot be held responsible for any potentional damage to your system!"
        alert.alertStyle = .critical
        alert.beginSheetModal(for: self.view.window!) { (response) in
            if response == NSAlertSecondButtonReturn {
                NSApp.terminate(self)
            }
        }
    }
    
    func readChimeStatus() {
        let out = Pipe()
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["defaults", "read", "com.apple.PowerChime",  "ChimeOnAllHardware"]
        task.standardOutput = out
        task.launch()
        task.waitUntilExit()
        let handle = out.fileHandleForReading
        let data = handle.readDataToEndOfFile()
        let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)

        
        let out2 = Pipe()
        let task2 = Process()
        task2.launchPath = "/usr/bin/env"
        task2.arguments = ["defaults", "read", "com.apple.PowerChime",  "ChimeOnNoHardware"]
        task2.standardOutput = out2
        task2.launch()
        task2.waitUntilExit()
        let handle2 = out2.fileHandleForReading
        let data2 = handle2.readDataToEndOfFile()
        let result2 = NSString(data: data2, encoding: String.Encoding.utf8.rawValue)
        
        if result == "0\n" && result2 == "1\n" {
            chimeStatus.stringValue = "Chime currently disabled"
        } else if result == "1\n" && result2 == "0\n" {
            chimeStatus.stringValue = "Chime currently enabled"
        } else {
            chimeStatus.stringValue = "Chime status unknown"
        }
    }

    @IBAction func disable(_ sender: Any) {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["defaults", "write", "com.apple.PowerChime",  "ChimeOnAllHardware", "-bool", "false"]
        task.launch()
        task.waitUntilExit()
        
        let task2 = Process()
        task2.launchPath = "/usr/bin/env"
        task2.arguments = ["defaults", "write", "com.apple.PowerChime", "ChimeOnNoHardware", "-bool", "true"]
        task2.launch()
        task2.waitUntilExit()
        
        let task3 = Process()
        task3.launchPath = "/usr/bin/env"
        task3.arguments = ["pkill", "-f", "PowerChime"]
        task3.launch()
        task3.waitUntilExit()
        
        readChimeStatus()
    }

    @IBAction func enable(_ sender: Any) {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["defaults", "write", "com.apple.PowerChime",  "ChimeOnAllHardware", "-bool", "true"]
        task.launch()
        task.waitUntilExit()
        
        let task2 = Process()
        task2.launchPath = "/usr/bin/env"
        task2.arguments = ["defaults", "write", "com.apple.PowerChime", "ChimeOnNoHardware", "-bool", "false"]
        task2.launch()
        task2.waitUntilExit()
        
        let task3 = Process()
        task3.launchPath = "/usr/bin/env"
        task3.arguments = ["pkill", "-f", "PowerChime"]
        task3.launch()
        task3.waitUntilExit()
        
        let task4 = Process()
        task4.launchPath = "/usr/bin/env"
        task4.arguments = ["open", "/System/Library/CoreServices/PowerChime.app"]
        task4.launch()
        task4.waitUntilExit()
        
        readChimeStatus()
    }
}

