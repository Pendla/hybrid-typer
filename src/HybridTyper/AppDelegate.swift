import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    
    let inputListener: InputListener = InputListener.shared

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Hide the initial window
        NSApplication.shared().windows.last?.close()
        
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
    }
    
    func openWindow() {
        NSApplication.shared().windows.last?.makeKeyAndOrderFront(nil)
        NSApplication.shared().activate(ignoringOtherApps: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

