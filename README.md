# Blackbird SDK

### Simplifying Core Image and image processing

## What is Blackbird?
Blackbird is a lightweight framework built entirely in *Swift* to give easy access to the powerful Core Image library.

## Why use Blackbird?
Blackbird automatically manages performance and makes coding easier.

## Usage

**Import Blackbird and CoreImage**

```swift
import Blackbird
import CoreImage
```

#### Displaying a CIImage

**UIKit:**

```swift
let bbView = UIBlackbirdView()
view.addSubview(bbView)
bbView.frame = view.bounds

bbView.image = {CIImage}
```

**SwiftUI:**

```swift
@State var image = CIImage()

struct ContentView: View {
  var body: some View {
    BlackbirdView(image: $image)
  }
}
```

#### Adding filters to a CIImage

```swift
let newImage = image.applyingFilter(.invert)
```



## Installation

* Use SPM in your Xcode Project

## Plans
* Easy portrait mode functionality.
* RAW Image processing.