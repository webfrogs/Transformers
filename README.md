[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/Platform-iOS|macOS|tvOS-4BC51D.svg?style=flat)](https://github.com/webfrogs/Transformers)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

*Transformers* is a framework to transform things elegantly using the power of Swift programming language. 

> Note: From version 1.0.0 Transforms only support Swift version 4.1 or newer
> If you want to use Transforms below Swift 4.1, specific git hash: `dc7b5179ae0db7e7b343fa6dcb050b759539f443`

## Feature

- Cast JSON data with type.
- Cast a swift dictionary to swift model which confirms `Codable` protocol.
- Cast a swift array whose item type is dictionary to swift model array whose items confirm `Codable` protocol.

## Installation

### Manual

Download the project, and drag the `Core` folder to your project.

### Carthage

Add this to `Cartfile`

```
github "webfrogs/Transformers" ~> 1.0
```

### Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 1),
]
```

## Usage

The most common scene in iOS programming is handle JSON data.

### Handle JSON 

```swift
let jsonString = """
{"key1": "value2"}
"""
let value1: String? = jsonString.data(using: String.Encoding.utf8)
    .flatMap({$0.toDictionary()})
    .flatMap({$0.value(key: "key1")})
print(value1 ?? "")
```

### RxSwift

If you also use [RxSwift](https://github.com/ReactiveX/RxSwift) in your project. *Transformers* can be easily integrated with RxSwift, and there is no need to transform JSON data fetched from http server to a model manually. All you have to do is define a model which confirms *Codable* protocol and use *Transformers* with the *map* function provided by RxSwift. 

Here is a demo code:

```swift
struct GithubAPIResult: Codable {
    let userUrl: String
    let issueUrl: String

    enum CodingKeys: String, CodingKey {
        case userUrl = "user_url"
        case issueUrl = "issues_url"
    }
}

let request = URLRequest(url: URL(string: "https://api.github.com")!)
let apiResult: Observable<GithubAPIResult> = URLSession.shared
    .rx.data(request: request)
    .map(Data.jsonToModelHandler)
apiResult.subscribe(onNext: { (result) in
    print(result)
}).disposed(by: kDisposeBag)
```



