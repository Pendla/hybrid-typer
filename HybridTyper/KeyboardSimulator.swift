import Cocoa
import Carbon

struct KeyboardButton {
    var down: CGEvent
    var up: CGEvent
}

class KeyboardSimulator {
    
    let location = CGEventTapLocation.cghidEventTap
    var eventSource: CGEventSource?
    
    var events: Dictionary<CGKeyCode, KeyboardButton>
    
    init() {
        self.eventSource = CGEventSource(stateID: .hidSystemState)
        events = [CGKeyCode: KeyboardButton]()
    }
    
    func paste(word: String) {
        guard let key = event(withVirtualKey: 0) else {
            return
        }
        
        for var char in word.utf16 {
            key.down.keyboardSetUnicodeString(stringLength: 1, unicodeString: &char)
            key.down.post(tap: location)
            key.up.post(tap: location)
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
            
            switch(modifier) {
            case CGKeyCode(kVK_Command): keyEvent.down.flags = .maskCommand
            case CGKeyCode(kVK_Option): keyEvent.down.flags = .maskAlternate
            case CGKeyCode(kVK_Shift): keyEvent.down.flags = .maskShift
            case CGKeyCode(kVK_Control): keyEvent.down.flags = .maskControl
            default: break
            }
            
            modifierEvent.down.post(tap: location)
            keyEvent.down.post(tap: location)
            keyEvent.up.post(tap: location)
            modifierEvent.up.post(tap: location)
        } else {
            keyEvent.down.post(tap: location)
            keyEvent.up.post(tap: location)
        }
    }
    
    /**
     
     */
    private func event(withVirtualKey key: CGKeyCode) -> KeyboardButton? {
        if let event = events[key] {
            return event;
        } else {
            guard let downEvent = CGEvent(keyboardEventSource: eventSource,
                                          virtualKey: key,
                                          keyDown: true) else {
                                            return nil
            }
            guard let upEvent = CGEvent(keyboardEventSource: eventSource,
                                        virtualKey: key,
                                        keyDown: false) else {
                                            return nil
            }
            
            events[key] = KeyboardButton(down: downEvent, up: upEvent)
            return events[key]
        }
    }
    
}
