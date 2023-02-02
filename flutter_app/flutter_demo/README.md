# read me

## 编译乱码解决
修改文件
./android/gradlew.bat
修改
set DEFAULT_JVM_OPTS=
为
set DEFAULT_JVM_OPTS="-Dfile.encoding=UTF-8"


## 使用组件及参考资料

### rive 动画效果

rive: ^0.9.0

### 时间线
在配网步骤中有使用
timeline_tile: ^2.0.0

### 嵌套路由
https://docs.flutter.dev/cookbook/effects/nested-nav
在配网过程中作为页面间跳转使用