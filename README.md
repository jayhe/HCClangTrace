# HCClangTrace

## Installation

HCClangTrace is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HCClangTrace', '~> 1.0.0'
```

## Usage
### 1. 在Build Settings中添加编译选项
Other C Flags增加`-fsanitize-coverage=func,trace-pc-guard`
如果你是OC Swift混编，则在Other Swift Flags增加`-sanitize-coverage=func`,   `-sanitize=undefined`
### 2.统计程序启动的函数执行情况
在你的首页的viewDidAppear函数中加上生成orderFile的函数，然后运行app
#### 2.1 编写测试代码测试c函数、pod库函数、block、swift方法
```objc
- (void)callSomeMethods {
    // call third lib method
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // call block
    self.testCallBlock();
    // call swift method
    [[TestCallSwift new] testCallSwiftMethod];
    // call c method
    testCallCMethod();
}

```
```objc
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [HCClangTrace generateOrderFile];
}

```
#### 2.2 执行查看效果
```powershell
2020-08-11 17:35:09.895881+0800 HCClangTrace_Example[47015:1422955] _main
-[HCAppDelegate window]
-[HCAppDelegate setWindow:]
-[HCAppDelegate application:didFinishLaunchingWithOptions:]
-[HCViewController viewDidLoad]
-[HCViewController setTestCallBlock:]
-[HCViewController callSomeMethods]
+[AFNetworkReachabilityManager sharedManager]
___45+[AFNetworkReachabilityManager sharedManager]_block_invoke
+[AFNetworkReachabilityManager manager]
+[AFNetworkReachabilityManager managerForAddress:]
-[AFNetworkReachabilityManager initWithReachability:]
-[AFNetworkReachabilityManager setNetworkReachabilityStatus:]
-[AFNetworkReachabilityManager startMonitoring]
-[AFNetworkReachabilityManager stopMonitoring]
-[AFNetworkReachabilityManager networkReachability]
___copy_helper_block_e8_32w
_AFNetworkReachabilityRetainCallback
___copy_helper_block_e8_32s40b
-[HCViewController testCallBlock]
___31-[HCViewController viewDidLoad]_block_invoke
_testCallCMethod
-[HCAppDelegate applicationDidBecomeActive:]
-[HCViewController viewDidAppear:]
___34-[HCViewController viewDidAppear:]_block_invoke

```

函数的调用符号会在app的沙盒的tmp目录下生成，trace.order的文件，可以直接去提取

### 3.如何统计pod库的函数调用
由于我们是通过编译选项去做的插桩，它只会生效于有该选项的工程，而pod库则是单独的工程，我们可以通过post_install来给pod库
自动加上这些编译选项
只需要在Podfile文件后面加上下面这段，Demo的Podfile也加上了这个
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      macho_type = config.build_settings['MACH_O_TYPE']
      #if macho_type == 'staticlib'
        if config.name == 'Debug'
          # 将依赖的pod项目的Other C Flags加上’-fsanitize-coverage=func,trace-pc-guard‘选项
          config.build_settings['OTHER_CFLAGS'] ||= ['$(inherited)', '-fsanitize-coverage=func,trace-pc-guard']
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)', '-fsanitize-coverage=func,trace-pc-guard']
        end
      #end
    end
  end
end
```

### 4.其他
有问题欢迎提issue，一起沟通解决，学习进步；
在使用之前可以先参照下我写的文档[iOS App启动时间优化--Clang插桩获取启动调用的函数符号](https://www.jianshu.com/p/23c78fad7b10)
