// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HCClangTrace",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "HCClangTrace",
            targets: ["HCClangTrace"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "HCClangTrace", // 库的名称
            dependencies: [], // 依赖
            path: "HCClangTrace", // 源代码路径
            sources: ["Classes"], // 具体的源代码资源，跟path组合就是"./HCClangTrace/Classes/"
            cSettings: [
                .headerSearchPath("Classes"),
            ]),
    ]
)
