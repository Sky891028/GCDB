GCDB Demo project
==============

GCDB is an extension for FMDB(https://github.com/ccgus/fmdb).

Installation
==============

### CocoaPods

1. Add `pod 'GCDB'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<GCDB/baseDatabase.h\> 
4. Inherit  @interface xxx : baseDatabase

### Manually

1. Download all the files in the `GCDB` subdirectory.
2. Add the source files to your Xcode project.
4. Link with required frameworks:
    * sqlite3
6. Import `FMDB`.




Requirements
==============
This library requires `iOS 7.0+` and `Xcode 7.0+`.

Notice
==============




<br/>
---
中文介绍
==============

GCDB是一个高性能的sql库。

为了尽量更加自由，没有提供ORM、自动存储等接口

全局队列管理，暂时没有多库的支持


演示项目
==============
查看并运行 `GCDB/GCDatabaseDemo.xcodeproj`


安装
==============

### CocoaPods

1. 在 Podfile 中添加  `pod 'GCDB'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 \<GCDB/baseDatabase.h\> 。
4. 类中继承  @interface xxx : baseDatabase

### 手动安装

1. 下载 GCDB 文件夹内的所有内容。
2. 将 GCDB 内的源文件添加(拖放)到你的工程。
3. 添加FMDB相关 并配置依赖
4. 导入 `GCDB`


系统要求
==============
该项目最低支持 `iOS 7.0` 和 `Xcode 7.0`。




