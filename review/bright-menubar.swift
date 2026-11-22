// Paints a bright band behind all windows at the top of every screen, so the
// menu bar shows a strong color (roughly what Aurora Glass does).
//
//   swift bright-menubar.swift            # magenta
//   swift bright-menubar.swift 00c8ff     # any hex color
//
// Quit with Ctrl-C.
import AppKit

let hex = CommandLine.arguments.dropFirst().first ?? "ff0080"
let rgb = Int(hex.trimmingCharacters(in: CharacterSet(charactersIn: "#")), radix: 16) ?? 0xff0080
let color = NSColor(
    srgbRed: CGFloat((rgb >> 16) & 0xff) / 255,
    green: CGFloat((rgb >> 8) & 0xff) / 255,
    blue: CGFloat(rgb & 0xff) / 255,
    alpha: 1
)

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

var windows: [NSWindow] = []
for screen in NSScreen.screens {
    // The menu bar plus a little below it.
    let height = screen.frame.maxY - screen.visibleFrame.maxY + 8
    let frame = NSRect(x: screen.frame.minX, y: screen.frame.maxY - height,
                       width: screen.frame.width, height: height)
    let window = NSWindow(contentRect: frame, styleMask: .borderless,
                          backing: .buffered, defer: false)
    // Just above the wallpaper, below every normal window.
    window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)) + 1)
    window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
    window.ignoresMouseEvents = true
    window.backgroundColor = color
    window.orderFrontRegardless()
    windows.append(window)
}

signal(SIGINT) { _ in exit(0) }
app.run()
