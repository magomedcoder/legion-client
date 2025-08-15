import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = NSMakeRect(0, 0, 450, 650)
    self.setFrame(windowFrame, display: true)
    self.minSize = NSSize(width: 450, height: 650)
    self.contentViewController = flutterViewController
    self.center()

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
