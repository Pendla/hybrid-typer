import Cocoa
import Carbon

struct KeyboardButton {
    var hold: CGEvent
    var release: CGEvent
}

class KeyboardSimulator {

    let location = CGEventTapLocation.cghidEventTap
    var eventSource: CGEventSource?

    var events: [CGKeyCode: KeyboardButton]

    init() {
        self.eventSource = CGEventSource(stateID: .hidSystemState)
        events = [CGKeyCode: KeyboardButton]()
    }

    func paste(word: String) {
        guard let key = event(withVirtualKey: 0) else {
            return
        }

        for var char in word.utf16 {
            key.hold.keyboardSetUnicodeString(stringLength: 1, unicodeString: &char)
            key.hold.post(tap: location)
            key.release.post(tap: location)
        }
    }

    /**
     
     */
    func delete(backwards: Bool, multiplier: Int) {
        for _ in 1...multiplier {
            let keyCode = CGKeyCode(backwards ? kVK_Delete : kVK_ForwardDelete)
            pressKey(withKeyCode: keyCode)
        }
    }

    /**
     
     */
    func pressKey(withKeyCode key: CGKeyCode, withModifier modifier: CGKeyCode? = nil) {
        guard let keyEvent = event(withVirtualKey: key) else {
            return
        }

        if let modifier = modifier {
            guard let modifierEvent = event(withVirtualKey: modifier) else {
                return
            }

            switch modifier {
            case CGKeyCode(kVK_Command): keyEvent.hold.flags = .maskCommand
            case CGKeyCode(kVK_Option): keyEvent.hold.flags = .maskAlternate
            case CGKeyCode(kVK_Shift): keyEvent.hold.flags = .maskShift
            case CGKeyCode(kVK_Control): keyEvent.hold.flags = .maskControl
            default: break
            }

            modifierEvent.hold.post(tap: location)
            keyEvent.hold.post(tap: location)
            keyEvent.release.post(tap: location)
            modifierEvent.release.post(tap: location)
        } else {
            keyEvent.hold.post(tap: location)
            keyEvent.release.post(tap: location)
        }
    }

    /**
     
     */
    private func event(withVirtualKey key: CGKeyCode) -> KeyboardButton? {
        if let event = events[key] {
            return event
        } else {
            guard let hold = CGEvent(keyboardEventSource: eventSource,
                                          virtualKey: key,
                                          keyDown: true) else {
                                            return nil
            }
            guard let release = CGEvent(keyboardEventSource: eventSource,
                                        virtualKey: key,
                                        keyDown: false) else {
                                            return nil
            }

            events[key] = KeyboardButton(hold: hold, release: release)
            return events[key]
        }
    }

}
