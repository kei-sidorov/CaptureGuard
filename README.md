# CaptureGuard

This Swift Package hides or shows parts of the screen when someone takes a screenshot, records the screen, or mirrors the phone to a Mac. It works with both **SwiftUI** and **UIKit**.

Check out the [full article for a detailed explanation](https://sidorov.tech/en/all/mastering-screen-recording-detection-in-ios-apps/) of how this library works, and [How it works](docs/how-it-works.md) for how it works now.

## Disclaimer

The authors of this package take **no responsibility** for any issues or consequences arising from its use. The code is provided **as-is**, and there is no guarantee that it will function as intended, especially with future updates to iOS.

**Important Notes:**
- The **SwiftUI** implementation is believed to be relatively safe for App Store submission. It uses public KVC with a secure text field, but depends on that field's undocumented internal canvas view. iPhone Mirroring detection also relies on two undocumented names — a notification name and a device name. Care should be taken with each iOS update to ensure that nothing breaks.
- The **UIKit** implementation (`CaptureGuardUIKit`) utilizes certain private framework symbols, which may lead to rejection from the App Store. It is recommended to use this package as a reference and consider enforcing similar functionality via alternative approaches.

**Compatibility**

- Swift 5.9+
- iOS 15+
- SwiftUI / UIKit
- Screenshots and recordings are **not** protected in the iOS Simulator, so test those on a real device. Hiding while the app is inactive does work there.

## What it covers

| Capture path | Covered | How |
|---|---|---|
| Screenshot | ✅ | layer exclusion (passive) |
| Screen recording | ✅ | layer exclusion + capture monitor |
| AirPlay mirroring | ✅ | capture monitor |
| Screen recording started on a Mac | ✅ | capture monitor |
| iPhone Mirroring | ⚠️ | inferred, not reported — see [docs/how-it-works.md](docs/how-it-works.md#iphone-mirroring) |
| iOS Simulator | partly | the layer mark and `isCaptured` are inert; hiding while inactive still works |

> [!WARNING]
> iPhone Mirroring detection is an undocumented workaround, not guaranteed protection; it may break with any iOS update. In UIKit, CaptureGuard saves a view's `alpha` before setting it to `0`, but cannot observe later `alpha` changes, which may reveal the view. Screenshot and recording protection uses a separate layer-exclusion mechanism.

## Installation

**Swift Package Manager** — in Xcode, go to **File > Add Package Dependencies**, paste the repository URL, and add `CaptureGuard` to your target. Add `CaptureGuardUIKit` too only if you want the view subclasses.

**CocoaPods**

```ruby
pod 'CaptureGuard'        # everything below
pod 'CaptureGuardUIKit'   # optional: view subclasses, uses private API
```

Two pods, not subspecs. If you skip `CaptureGuardUIKit`, the private symbols are never compiled into your app.

## SwiftUI Usage

Use `hiddenOnCapture()` and `visibleOnlyOnCapture()` to control what a capture sees.

```swift
import SwiftUI
import CaptureGuard

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hidden on capture")
                .hiddenOnCapture() // hidden from screenshots, recordings and mirroring

            Text("Visible only on capture")
                .visibleOnlyOnCapture() // invisible on screen, present in a screenshot
        }
        .font(.largeTitle)
    }
}
```

## UIKit Usage

Call `makeHiddenOnCapture()` on a view you already have. There is no wrapper class to adopt.

```swift
import UIKit
import CaptureGuard

class ViewController: UIViewController {

    @IBOutlet private var cardNumberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        cardNumberLabel.makeHiddenOnCapture()
    }
}
```

`CaptureGuardUIKit` also gives you `HiddenOnCaptureView` and `VisibleOnlyOnCaptureView`. They do the same for a whole container, and you can set them as the class of a view in Interface Builder.

```swift
import CaptureGuardUIKit

let box = HiddenOnCaptureView()
```

The mark is set on this view's layer only, but a capture leaves out that layer and everything drawn inside it — so calling it on a container protects the container's contents too.

## Reading the capture state yourself

```swift
CaptureMonitor.shared.isCapturing              // a capture is running
CaptureMonitor.shared.isHidingContent          // ...or the app is not active
CaptureMonitor.shared.detectsMirroring = false // opt out of the iPhone Mirroring guess
```

Both are `@Published`, so you can observe them in SwiftUI or Combine. If you hide your own
content by hand, follow `isHidingContent`, not `isCapturing` — otherwise the content is
still on screen when iOS snapshots the app for the switcher.

Protected views are also hidden while the app is not active, so the secret stays out of the app switcher snapshot. `isCapturing` reports captures only, and stays `false` in that case.

`CaptureMonitor` sets `alpha` to 0 on every view you pass to `makeHiddenOnCapture()`, and puts the previous value back afterwards. It uses `alpha` rather than `isHidden` so it does not collapse stack-view layouts or fight your own `isHidden`. Do not animate `alpha` on those views yourself.

## Layout

```
Sources/
├── CaptureGuard/
│   ├── Core/        the layer primitive + UIView entry point
│   ├── SwiftUI/     the two view modifiers
│   └── Monitor/     CaptureMonitor, DarwinNotification
├── CaptureGuardUIKit/   view subclasses; the only target using private CAFilter
└── CNotify/             C shim so Swift can import <notify.h>
```

## Documentation

[How it works](docs/how-it-works.md) covers the two mechanisms with diagrams, why iPhone Mirroring detection is a guess and what was measured on device, and the limits — silent failure, and what breaks on an iOS update.

Read the [Limits](docs/how-it-works.md#limits) section before you ship. Most failures there are silent: the content stays visible and nothing is logged.

## License

This package is licensed under the MIT License. For more details, refer to the LICENSE file in the repository.
