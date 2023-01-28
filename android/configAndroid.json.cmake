{
 "description": "This file is to be read by androiddeployqt",
 "application-binary": "GCompris",
  "architectures": {
    @QT_ANDROID_ARCHITECTURES@
  },
 "android-package-source-directory": "@PACKAGE_SOURCE_ANDROID@/",
 "android-package": "net.gcompris",
 "android-extra-plugins": "@CMAKE_BINARY_DIR@/lib/qml/Box2D.2.0",
 "sdkBuildToolsRevision": "@ANDROID_SDK_BUILD_TOOLS_REVISION@",
 "ndk": "@ANDROID_NDK@",
 "ndk-host": "@_HOST@",
 "qml-root-path": "@CMAKE_SOURCE_DIR@/src",
 "qt": "@QT6_INSTALL_PREFIX@",
 "rcc-binary": "@QT_HOST_PATH@/libexec/rcc",
 "qml-importscanner-binary": "@QT_HOST_PATH@/libexec/qmlimportscanner",
 "sdk": "@ANDROID_SDK_ROOT@",
 @STDCPP_PATH@,
 "tool-prefix": "llvm",
 "toolchain-prefix": "llvm",
 "useLLVM": true
}
