import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)

    var inputManager: InputManager

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Hide the initial window
        NSApplication.shared().windows.last?.close()

        NSLog("Preparing and loading")

        let dictionaryFolder = "Resources/Dictionaries"
        guard let path = Bundle.main.path(forResource: "swedish", ofType: "hybdic", inDirectory: dictionaryFolder) else {
            NSLog("Couldn't find dictionary")
            return
        }

        inputManager = InputManager(withDictionaryPath: path)
        createStatusBar()
    }

    private func createStatusBar() {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
        }

        let menu = NSMenu()
        menu.addItem(withTitle: "Preferences",
                     action: #selector(openWindow),
                     keyEquivalent: ",")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit",
                     action: #selector(NSApplication.terminate(_:)),
                     keyEquivalent: "q")

        statusItem.menu = menu
        
        NSLog("Finished loading status bar")
    }

    func openWindow() {
        NSApplication.shared().windows.last?.makeKeyAndOrderFront(nil)
        NSApplication.shared().activate(ignoringOtherApps: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}
