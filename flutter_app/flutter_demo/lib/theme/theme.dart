import 'dart:ui';

import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  // Define the default brightness and colors.
  brightness: Brightness.light,

  // scaffoldBackgroundColor: const Color(0xFFFFF3EB),

  // primaryColor: const Color(0xff462F4D), // add 0xff
  // splashColor: const Color(0xff73503D),
  // appBarTheme: const AppBarTheme(
  //   backgroundColor: Color(0xFFFFF3EB),
  //   //
  // ),

  // cardTheme: const CardTheme(color: Color(0xFFF9E3D5), elevation: 0),

  // shadowColor: const Color(0xFFF9E3D5),
  // iconTheme: IconThemeData(color: Colors.deepPurple[900]),
  // // Define the default font family.
  // fontFamily: 'Montserrat',

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
);

final ThemeData darkTheme = ThemeData(
  // Define the default brightness and colors.
  brightness: Brightness.dark,
  // scaffoldBackgroundColor: Colors.brown[900],
  // appBarTheme: const AppBarTheme(
  //   backgroundColor:Color(0xFF3E2723),
  // ),
  // primaryColor: Colors.orange[100],
  // iconTheme: IconThemeData(color: Colors.orange[100]),
  // Define the default font family.
  fontFamily: 'Montserrat',
);

// factory ThemeData({
//   // 应用整体主题的亮度
//   // 用于按钮之类的小部件，以确定在不使用主色或强调色时选择什么颜色
//   Brightness brightness,
//   // 定义一个单一的颜色以及十个色度的色块
//   MaterialColor primarySwatch,
//   // 应用程序主要部分的背景颜色（Toolbars、TabBar等）
//   Color primaryColor,
//   // primaryColor的亮度
//   // 用于确定文本的颜色和放置在主颜色之上的图标（例如工具栏文本）
//   Brightness primaryColorBrightness,
//   // primaryColor的浅色版
//   Color primaryColorLight,
//   // primaryColor的深色版
//   Color primaryColorDark,
//   // 小部件的前景色（旋钮、文本、覆盖边缘效果等）
//   Color accentColor,
//   // accentColor的亮度
//   Brightness accentColorBrightness,
//   // MaterialType.canvas 的默认颜色
//   Color canvasColor,
//   // 阴影层颜色
//   Color shadowColor,
//   // Scaffold的默认颜色
//   // 典型Material应用程序或应用程序内页面的背景颜色
//   Color scaffoldBackgroundColor,
//   // BottomAppBar的默认颜色
//   Color bottomAppBarColor,
//   // Card的颜色
//   Color cardColor,
//   // Divider和PopupMenuDivider的颜色，也用于ListTile之间、DataTable的行之间等
//   Color dividerColor,
//   // 获取焦点时颜色
//   Color focusColor,
//   // 鼠标所指位置颜色（Web、PC、macOS使用）
//   Color hoverColor,
//   // 选中在泼墨动画期间使用的突出显示颜色，或用于指示菜单中的项
//   Color highlightColor,
//   // 墨水飞溅的颜色
//   // InkWell使用
//   Color splashColor,
//   // 定义由InkWell和InkResponse反应产生的墨溅的外观
//   InteractiveInkFeatureFactory splashFactory,
//   // 用于突出显示选定行的颜色
//   Color selectedRowColor,
//   // 用于处于非活动(但已启用)状态的小部件的颜色
//   // 例如，未选中的复选框
//   // 通常与accentColor形成对比，也看到disabledColor
//   Color unselectedWidgetColor,
//   // 禁用状态下部件的颜色，无论其当前状态如何
//   // 例如，一个禁用的复选框（可以选中或未选中）
//   Color disabledColor,
//   // RaisedButton按钮中使用的Material 的默认填充颜色
//   Color buttonColor,
//   // 定义按钮部件的默认配置，如RaisedButton和FlatButton
//   ButtonThemeData buttonTheme,
//   // ToggleButton主题
//   ToggleButtonsThemeData toggleButtonsTheme,
//   // 选定行时PaginatedDataTable标题的颜色
//   Color secondaryHeaderColor,
//   // 文本框中文本选择的颜色，如TextField
//   @Deprecated('TextSelectionThemeData.selectionColor')
//   Color textSelectionColor,
//   // 文本框中光标的颜色，如TextField
//   @Deprecated('TextSelectionThemeData.cursorColor')
//   Color cursorColor,
//   // 用于调整当前选定的文本部分的句柄的颜色
//   @Deprecated('TextSelectionThemeData.selectionHandleColor')
//   Color textSelectionHandleColor,
//   // 与主色形成对比的颜色
//   // 例如用作进度条的剩余部分
//   Color backgroundColor,
//   // Dialog 元素的背景颜色
//   Color dialogBackgroundColor,
//   // 选项卡中选定的选项卡指示器的颜色
//   Color indicatorColor,
//   // 用于提示文本或占位符文本的颜色
//   // 例如在TextField中
//   Color hintColor,
//   // 用于输入验证错误的颜色
//   // 例如在TextField中
//   Color errorColor,
//   // 用于突出显示Switch、Radio和Checkbox等可切换小部件的活动状态的颜色
//   Color toggleableActiveColor,
//   // 文本字体
//   String fontFamily,
//   // 文本的颜色与卡片和画布的颜色形成对比
//   TextTheme textTheme,
//   // 与primaryColor形成对比的文本主题
//   TextTheme primaryTextTheme,
//   // 与accentColor形成对比的文本主题
//   TextTheme accentTextTheme,
//   // InputDecorator、TextField和TextFormField的默认InputDecoration值
//   InputDecorationTheme inputDecorationTheme,
//   // Icon图标主题
//   // 与卡片和画布颜色形成对比的图标主题
//   IconThemeData iconTheme,
//   // 与primaryColor形成对比的图标主题
//   IconThemeData primaryIconTheme,
//   // 与accentColor形成对比的图标主题
//   IconThemeData accentIconTheme,
//   // 用于呈现Slider的颜色和形状
//   SliderThemeData sliderTheme,
//   // 用于自定义选项卡栏指示器的大小、形状和颜色的主题
//   TabBarTheme tabBarTheme,
//   // 消息提示Tooltip
//   TooltipThemeData tooltipTheme,
//   // Card的颜色和样式
//   CardTheme cardTheme,
//   // Chip的颜色和样式
//   ChipThemeData chipTheme,
//   // 平台
//   TargetPlatform platform,
//   // 配置某些Material部件的点击区域大小
//   MaterialTapTargetSize materialTapTargetSize,
//   // 是否应用elevation覆盖颜色
//   bool applyElevationOverlayColor,
//   // 页面转场主题样式
//   PageTransitionsTheme pageTransitionsTheme,
//   // 用于自定义Appbar的颜色、高度、亮度、iconTheme和textTheme的主题
//   AppBarTheme appBarTheme,
//   // 用于Scrollbar
//   ScrollbarThemeData scrollbarTheme,
//   // 自定义BottomAppBar的形状、高度和颜色的主题
//   BottomAppBarTheme bottomAppBarTheme,
//   // 拥有13种颜色，可用于配置大多数组件的颜色
//   ColorScheme colorScheme,
//   // 自定义Dialog的主题形状
//   DialogTheme dialogTheme,
//   // FloatingActionButton的主题样式，是Scaffold属性的
//   FloatingActionButtonThemeData floatingActionButtonTheme,
//   // NavigationRail样式（1.17新加入Widget）
//   NavigationRailThemeData navigationRailTheme,
//   // 用于配置TextTheme、primaryTextTheme和accentTextTheme的颜色和几何文本主题值
//   Typography typography,
//   // cupertino覆盖的主题样式
//   CupertinoThemeData cupertinoOverrideTheme,
//   // 弹出的snackBar的主题样式
//   SnackBarThemeData snackBarTheme,
//   // 底部滑出对话框的主题样式
//   BottomSheetThemeData bottomSheetTheme,
//   // 弹出菜单对话框的主题样式
//   PopupMenuThemeData popupMenuTheme,
//   // Material材质的Banner主题样式
//   MaterialBannerThemeData bannerTheme,
//   // Divider组件（横向线条组件）的主题样式
//   DividerThemeData dividerTheme,
//   // 末端按钮对齐的容器的主题样式
//   ButtonBarThemeData buttonBarTheme,
//   // BottomNavigationBar（底部导航栏）的主题样式
//   BottomNavigationBarThemeData bottomNavigationBarTheme,
//   // TimePicker（时间选择器）的主题样式
//   TimePickerThemeData timePickerTheme,
//   // TextButton的主题样式（1.22新加入Widget）
//   TextButtonThemeData textButtonTheme,
//   // ElevatedButton的主题样式（1.22新加入Widget）
//   ElevatedButtonThemeData elevatedButtonTheme,
//   // ElevatedButton的主题样式（1.22新加入Widget）
//   OutlinedButtonThemeData outlinedButtonTheme,
//   // 选择文本控制器的主题样式
//   TextSelectionThemeData textSelectionTheme,
//   // DataTable（表格）的主题样式
//   DataTableThemeData dataTableTheme,
//   // Checkbox的主题样式
//   CheckboxThemeData checkboxTheme,
//   // Radio的主题样式
//   RadioThemeData radioTheme,
//   // Switch的主题样式
//   SwitchThemeData switchTheme,
//   // 默认为true 1.19稳定版本后去除
//   bool fixTextFieldOutlineLabel,
//   @Deprecated('No longer used by the framework, please remove any reference to it. ')
//   bool useTextSelectionTheme,
// })
