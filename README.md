# CaptureGuard

This Swift Package helps developers hide or show parts of the screen when a screenshot or screen recording is taken on iOS devices, like iPhones and iPads. It works with both **SwiftUI** and **UIKit** frameworks.

Check out the [full article for a detailed explanation](https://sidorov.tech/en/all/mastering-screen-recording-detection-in-ios-apps/) of how this library works.

## Disclaimer

The authors of this package take **no responsibility** for any issues or consequences arising from its use. The code is provided **as-is**, and there is no guarantee that it will function as intended, especially with future updates to iOS.

**Important Notes:**
- The **SwiftUI** implementation is believed to be relatively safe for App Store submission. However, care should be taken with each iOS update to ensure that nothing breaks.
- The **UIKit** implementation utilizes certain private framework symbols, which may lead to rejection from the App Store. It is recommended to use this package as a reference and consider enforcing similar functionality via alternative approaches.

**Compatibility**

- Swift 5.9
- iOS 15+
- SwiftUI / UIKit
- This package will **not function** (no effect) in the iOS Simulator and must be tested on a real device.

## Installation

1. In Xcode, go to **File > Add Packages**.
2. Enter the package repository URL.
3. Select your target and include the package in your project.

## SwiftUI Usage

You can use the provided `hiddenOnCapture()` and `visibleOnlyOnCapture()` view modifiers to control the visibility of views when a screenshot or screen recording occurs.

### Example

```swift
import SwiftUI
import ScreenCaptureView

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hidden on capture")
                .hiddenOnCapture() // This text will be hidden when capturing the screen
            
            Text("Visible only on capture")
                .visibleOnlyOnCapture() // This text will be visible only during capture
        }
        .font(.largeTitle)
    }
}
```

## UIKit Usage

For UIKit, you can subclass either HiddenOnCaptureView or VisibleOnlyOnCaptureView, or you can directly apply the makeHideableOnCapture() method on any UIView’s CALayer to achieve the same effect.

### Example

```swift
import UIKit
import ScreenCaptureView

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hiddenOnCaptureView = HiddenOnCaptureView()
        hiddenOnCaptureView.backgroundColor = .red
        hiddenOnCaptureView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hiddenOnCaptureView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addSubview(hiddenOnCaptureView)
        
        let visibleOnlyOnCaptureView = VisibleOnlyOnCaptureView()
        visibleOnlyOnCaptureView.backgroundColor = .green
        visibleOnlyOnCaptureView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        visibleOnlyOnCaptureView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addSubview(visibleOnlyOnCaptureView)
        
        // Alternatively, use `makeHiddenOnCapture()` method on any UIView's layer
        hiddenOnCaptureView.layer.makeHideableOnCapture()
    }
}
```

## License

This package is licensed under the MIT License. For more details, refer to the LICENSE file in the repository.