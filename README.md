[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/Platform-iOS|macOS|tvOS-4BC51D.svg?style=flat)](https://github.com/webfrogs/Transformers)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

*Transformers* is a framework to transform things elegantly using the power of Swift programming language. 

Support Swift version: 4.1 or newer

## Feature

- Type casting of JSON object.
- Cast a swift dictionary to swift model which confirms `Codable` protocol.
- Cast a swift array whose item type is dictionary to swift model array whose items confirm `Codable` protocol.

## Installation

### Manual

Download the project, and drag the `Core` folder to your project.

### Carthage

Add this to `Cartfile`

```
github "webfrogs/Transformers" "master"
```

### Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", .branch("master")),
]
```

## Usage

The most common scene in iOS programming is handle JSON data.

### Handle JSON 

```swift
do {
    let jsonString = """
    {"key1": "value2"}
    """
    let jsonObject = try JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!, options: [])
    let dic = try Transformer.JSON.toDictionary(jsonObject)
    print(dic)
    let value: String = try Transformer.Dictionary.value(key: "key1")(dic)
    print(value)
} catch {
    print(error)
}
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
    .rx.json(request: request)
    .map(Transformer.JSON.toDictionary)
    .map(Transformer.Dictionary.toModel)
```



