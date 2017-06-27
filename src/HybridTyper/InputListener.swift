import Cocoa
import Carbon

/**
 
 */
final class InputListener {

    static let shared = InputListener()
    let keyboardSimulator = KeyboardSimulator()

    var dictionary = Set<String>()

    private var word: String = ""

    private init() {
        setupListener()
    }

    private func setupListener() {
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown,
                                          handler: onKeyDown(_:))
    }

    private func onKeyDown(_ event: NSEvent) {
        guard let input = event.characters else {
            NSLog("There were no characters in the input")
            return
        }

        guard event.keyCode != CGKeyCode(kVK_Delete) else {
            return
        }

        if event.keyCode == CGKeyCode(kVK_Space) {
            let modifiedWord = word
                .replacingOccurrences(of: "[", with: "å")
                .replacingOccurrences(of: "{", with: "Å")
                .replacingOccurrences(of: "'", with: "ä")
                .replacingOccurrences(of: "\"", with: "Ä")
                .replacingOccurrences(of: ";", with: "ö")
                .replacingOccurrences(of: ":", with: "Ö")

            print(dictionary.contains(modifiedWord))
            print(modifiedWord.characters.count)

            if modifiedWord != word && dictionary.contains(modifiedWord.replacingOccurrences(of: ".", with: "")) {
                keyboardSimulator.delete(backwards: true, multiplier: word.characters.count + 1)
                keyboardSimulator.paste(word: modifiedWord)
                keyboardSimulator.pressKey(withKeyCode: CGKeyCode(kVK_Space))
            }

            word = ""
        } else {
            word.append(input)
        }
    }
}
