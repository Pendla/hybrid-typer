import Cocoa
import Carbon

/**
 
 */
final class InputListener {

    static let shared = InputListener()
    let keyboardSimulator = KeyboardSimulator()

    private var word: String = ""

    private init() {
        setupListener()
    }

    private func setupListener() {
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown,
                                          handler: onKeyDown(_:))
    }

    private func onKeyDown(_ event: NSEvent) {
//        print("Event: \(event)")

        guard let input = event.characters else {
            NSLog("There were no characters in the input")
            return
        }

        guard event.keyCode != CGKeyCode(kVK_Delete) else {
            return
        }

        word.append(input)
        print(word)

        if event.keyCode == CGKeyCode(kVK_Space) {
            let modifiedWord = word
                .replacingOccurrences(of: "[", with: "å")
                .replacingOccurrences(of: "{", with: "Å")
                .replacingOccurrences(of: "'", with: "ä")
                .replacingOccurrences(of: "\"", with: "Ä")
                .replacingOccurrences(of: ";", with: "ö")
                .replacingOccurrences(of: ":", with: "Ö")

            // TODO If word is in dictionary
            if modifiedWord != word {
                keyboardSimulator.delete(backwards: true, multiplier: word.characters.count)
                keyboardSimulator.paste(word: modifiedWord)
            }

            word = ""
        }
    }
}
