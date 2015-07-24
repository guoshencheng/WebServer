# WebServer

[![CI Status](http://img.shields.io/travis/guoshencheng/WebServer.svg?style=flat)](https://travis-ci.org/guoshencheng/WebServer)
[![Version](https://img.shields.io/cocoapods/v/WebServer.svg?style=flat)](http://cocoapods.org/pods/WebServer)
[![License](https://img.shields.io/cocoapods/l/WebServer.svg?style=flat)](http://cocoapods.org/pods/WebServer)
[![Platform](https://img.shields.io/cocoapods/p/WebServer.svg?style=flat)](http://cocoapods.org/pods/WebServer)

## Installation

WebServer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WebServer', :git => 'http://10.0.2.217:7777/shenchengguo/WebServer.git'
```
and then

```bash
pod install
```

## Usage

- This package include some class about net working,  All of this was dependence [AFNetworking](https://github.com/AFNetworking/AFNetworking),   so if you have interesting in the context of the package,please look up AFNetworking.
This package is not involving Business logic,  so if you want to use this package into your project,  you may add some category.
- For Example 
ApiRequest+BulidFactory.h&m
you may add some function like:

```objc
+ (instancetype)requestForTestServer {
    ApiRequest *request = [self defaultRequest];
    request.url = URL;
    request.parameters = @{@"id":@"books" };
    return  request;
}
```
ApiResponse+Explanation.h&m
you may add some function like: 

```objc
- (NSString *)imageUrlResponseFactory {
    NSDictionary *model = [self.entity objectForKey:@"model"];
    return [model objectForKey:@"url"];
}
```
if you want to make service custom and handle relogin,  you may add a service category like ApiService+Relogin.h&m
you may add some function like:

```objc
- (BOOL)handleResponse:(ApiResponse *)apiResponse reloginIfNecessaryWithApiRequest:(ApiRequest *)apiRequest {
    if ([apiResponse sessionTimeout]) {
        Owener *owner = [Owener getOwenserInfomation];
        [self sendReLoginWithRequest:apiRequest andLoginRequest:[ApiRequest requestForLoginWithUserId:[owner.userId stringValue] nickName:owner.nickName avatarUrl:owner.avatarUrl]];
        return YES;
    } else {
        return NO;
    }   
}

```
##用法（中文版）

- 这个包是专门对网络操作设计的，所有的里面的内容几乎都依赖[AFNetworking](https://github.com/AFNetworking/AFNetworking)， 所以如果你对里面的内容感兴趣的话，可以去查看AFNetworking，这个包没有涉及业务逻辑，所以，如果你想在工程中使用这个包，有可能需要增加一些扩展类。
- 例子 
ApiRequest+BulidFactory.h&m
你可能会加上这些方法:

```objc
+ (instancetype)requestForTestServer {
    ApiRequest *request = [self defaultRequest];
    request.url = URL;
    request.parameters = @{@"id":@"books" };
    return  request;
}
```
ApiResponse+Explanation.h&m
你可能会加上这些方法: 

```objc
- (NSString *)imageUrlResponseFactory {
    NSDictionary *model = [self.entity objectForKey:@"model"];
    return [model objectForKey:@"url"];
}
```
如果你想处理一些自定义ApiService，比如加上重登陆的方法，你可能需要增加一个扩展类比如 ApiService+Relogin.h&m
你可能会加上这些方法:

```objc
- (BOOL)handleResponse:(ApiResponse *)apiResponse reloginIfNecessaryWithApiRequest:(ApiRequest *)apiRequest {
    if ([apiResponse sessionTimeout]) {
        Owener *owner = [Owener getOwenserInfomation];
        [self sendReLoginWithRequest:apiRequest andLoginRequest:[ApiRequest requestForLoginWithUserId:[owner.userId stringValue] nickName:owner.nickName avatarUrl:owner.avatarUrl]];
        return YES;
    } else {
        return NO;
    }
}
```

## Author

guoshencheng, guoshencheng1@gmail.com

## License

WebServer is available under the MIT license. See the LICENSE file for more info.
