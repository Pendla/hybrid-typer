import Cocoa
import Carbon

class InputManager {
    
    let keyboardSimulator = KeyboardSimulator()

    var wordHelper: WordHelper

    private var word: String = ""

    init(withDictionaryPath path: String) {
        wordHelper = WordHelper(withDictionaryPath: path)
        initInputListener()
    }

    private func initInputListener() {
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: handleKeyDown(_:))
    }

    private func handleKeyDown(_ event: NSEvent) {
        guard let input = event.characters else {
            NSLog("There were no characters in the input")
            return
        }

        if event.keyCode == CGKeyCode(kVK_Delete) {
            guard word.characters.count > 0 else {
                return
            }

            NSLog("word before deletion: %@", word)
            word.removeSubrange(word.index(before: word.endIndex)..<word.endIndex)
            NSLog("word after deletion: %@", word)
        } else {
            // Append the character just typed as long as the user actually inserting somthing into
            // the input. Note that even the potential space that creates a new word is included in the
            // word that we replace.
            word.append(input)

            // If we have a word divier, try to convert and replace the word we just finished
            if event.keyCode == CGKeyCode(kVK_Space) {
                let modifiedWord = wordHelper.convert(word: word)

                NSLog("modified word: %@", modifiedWord)

                // Determine if the word should/needs to be replaced and perform replacement if it
                // is required by requesting the keyboard simulator to do so.
                if wordHelper.shouldReplace(word: word, withWord: modifiedWord) {
                    NSLog("Replacing word: %@ with new word: %@", word, modifiedWord)
                    keyboardSimulator.replace(word: word, withWord: modifiedWord)
                }

                // We  had a word separator, thus we are now writing a new word, reset the
                // word tracking.
                word = ""
            }

            NSLog("active word: %@", word)
        }

    }

}
