import Foundation

class WordHelper {

    /// A dictionary containing all the words that we want to replace with
    fileprivate var dictionary = Set<String>()

    init(withDictionary dictionary: Set<String>) {
        self.dictionary = dictionary
    }

    convenience init(withDictionaryPath path: String) {
        NSLog("Loading dictionary at %@", path)

        var temporaryDictionary = Set<String>()
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let words = data.components(separatedBy: .newlines)

            for word in words {
                temporaryDictionary.insert(word)
            }
            NSLog("Finished loading dictionary -- %@ words read", temporaryDictionary.count.description)
        } catch {
            NSLog("ERROR: %@", error as NSError)
        }

        self.init(withDictionary: temporaryDictionary)
    }

    func convert(word: String) -> String {
        var convertedWord = word
        let charMappings = ["[": "å", "{": "Å", "'": "ä", "\"": "Ä", ";": "ö", ":": "Ö"]
        for (key, value) in charMappings {
            convertedWord = convertedWord.replacingOccurrences(of: key, with: value)
        }
        return convertedWord
    }

    func inDictionary(word: String) -> Bool {
        return dictionary.contains(word.replacingOccurrences(of: " ", with: ""))
    }

    func shouldReplace(word originalWord: String, withWord modifiedWord: String) -> Bool {
        return modifiedWord != originalWord && inDictionary(word: modifiedWord)
    }
}
