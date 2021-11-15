# QRCodeView

A simple macOS/iOS/tvOS QR Code generator view for Swift, Objective-C and SwiftUI.

<p align="center">
    <img src="https://img.shields.io/github/v/tag/dagronf/QRCodeView" />
    <img src="https://img.shields.io/badge/macOS-10.11+-red" />
    <img src="https://img.shields.io/badge/iOS-13+-blue" />
    <img src="https://img.shields.io/badge/tvOS-13+-orange" />
</p>
<p align="center">
    <img src="https://img.shields.io/badge/License-MIT-lightgrey" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>

![Screenshot](./Art/screenshot.png)

## Why?

It's nice to have a simple drop-in component for displaying a QR code.

## Features

* Supports Swift and Objective-C
* Supports NSView (macOS), UIView (iOS/tvOS) and SwiftUI
* Size to fit available provided space
* Configurable foreground/background colors

## QRCodeView

The NSView/UIView implementation.

### Parameters

| Parameter          | Type                         | Description                                            |
|--------------------|------------------------------|--------------------------------------------------------|
| `data`             | `Data`                       | The QR Code content                                    |
| `errorCorrection`  | `QRCodeView.ErrorCorrection` | The level of error collection when generating the code |
| `foreColor`        | `CGColor`                    | The QR code color                                      |
| `backColor`        | `CGColor`                    | The background color for the control                   |

### Methods

```swift
static func Image(content: String, size: CGSize) -> IMAGETYPE?
```

Returns an image representation of the QR code

### Example

```swift
let view = QRCodeView()
view.content = "QR Code content"
view.errorCorrection = .max
```

## QRCodeViewUI

The SwiftUI implementation is a basic Shape type. So anything you can do with a (eg.) Swift Rectangle shape you 
can do with a QRCode.

For example, you can use `.fill` to set the color content (eg. a linear gradient, solid color etc), add a drop shadow,
add a transform etc...


| Parameter         | Type                         | Description                                            |
|-------------------|------------------------------|--------------------------------------------------------|
| `data`            | `Data`                       | The QR Code content                                    |
| `errorCorrection` | `QRCodeView.ErrorCorrection` | The level of error collection when generating the code |

### Example

```swift
struct ContentView: View {

   @State var content: String = "This is a test of the QR code control"
   @State var correction: QRCodeView.ErrorCorrection = .low

   var body: some View {
      Text("Here is my QR code")
      QRCode(
         text: content,
         errorCorrection: correction
      )
      .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
      .shadow(color: .black, radius: 1, x: 1, y: 1)
      .frame(width: 250, height: 250, alignment: .center)
   }
}
```

## License

MIT. Use it for anything you want, just attribute my work. Let me know if you do use it somewhere, I'd love to hear about it!

```
MIT License

Copyright (c) 2021 Darren Ford

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```