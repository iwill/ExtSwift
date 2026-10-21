# ExtSwift

Extensions for Swift

## Contents

- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Features](#features)
- [Usage](#usage)
- [Credits](#credits)
- [License](#license)

## Requirements

- iOS 15+ / tvOS 16+ / macOS 12+
- Xcode 27+
- Swift 6.4+

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/extswift). (Tag 'extswift')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/extswift).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

### Swift Package Manager

```
.package(url: "https://github.com/iwill/ExtSwift", from: "3.0.0")
```

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate ExtSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '27.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ExtSwift', :git => 'https://github.com/iwill/ExtSwift.git', :tag => '3.0.0'
end
```

or

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '27.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ExtSwift', '~> 2.1'
end
```

Then, run the following command:

```bash
$ pod install
```

### Features

- [x] Basic
    - [x] Falsify
    - [x] Operators
    - [x] NameSpace
- [ ] Foundation
    - [x] ifEmpty
- [ ] UIKit
- [ ] WebKit

## TODO: Usage

### TODO: Quick Start

```swift
import ExtSwift
```

### Playground

TODO: You can try ExtSwift in Playground.

**Note:**

> To try ExtSwift in playground, open `ExtSwift.xcworkspace` and build `ExtSwift.framework` for any simulator first.

### Basic
- TODO: Falsify
- TODO: Operators
- TODO: NameSpace
### TODO: Foundation?
- TODO: ifEmpty
### TODO: UIKit
### TODO: WebKit

## Credits

Míng ([@minglq](https://twitter.com/minglq/))

## License

ExtSwift is released under the MIT license. See [LICENSE](./LICENSE) for details.
