import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

/// 屏幕适配
/// author：whg
/// date：2021-12-01
///
class ScreenAdapt {
  double portraitUiHight = 0; //竖版设计稿高度
  double portraitUiWidth = 0; //竖版设计稿宽度
  double lanscapeUiHight = 0; //横板设计稿高度
  double lanscapeUiWidth = 0; //横板设计稿宽度
  double screenWidth = 0; //屏幕宽度（较大一侧），竖版app中以这侧为屏幕高度
  double screenHeight = 0; //屏幕高度（较小一侧），竖版app中以这侧为屏幕宽度
  double statusBarHeight = 0; //状态栏高度
  MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);

  double px = 0;
  double highRatio = 0;
  double widthRatio = 0;

  ///屏幕适配初始化
  void initialize(
      {double lanscapeWidth = 1024,
      double lanscapeHight = 600,
      double portraitWidth = 375,
      double portraitHight = 812}) {
    screenWidth = mediaQuery.size.width;
    // screenWidth = mediaQuery.textScaleFactor;
    screenHeight = mediaQuery.size.height;
    if (screenHeight > screenWidth) {
      ///以较宽一侧作为屏幕宽度,竖版app中以这侧为屏幕高度
      double tempVar = screenWidth;
      screenWidth = screenHeight;
      screenHeight = tempVar;
    }
    portraitUiHight = portraitHight;
    portraitUiWidth = portraitWidth;
    lanscapeUiHight = lanscapeHight;
    lanscapeUiWidth = lanscapeWidth;

    px = screenWidth / lanscapeWidth;
    highRatio = screenHeight / lanscapeHight;
  }

  ///竖版设计稿 按宽度设置像素
  double getPortraitHorizen(double size) {
    if (screenWidth == 0) {
      initialize();
    }
    return screenHeight / portraitUiWidth * size;
  }

  ///竖版设计稿  按高度比例设置像素
  double getPortraitVertical(double size) {
    if (screenWidth == 0 || portraitUiHight == 0) {
      initialize();
    }
    return screenWidth / portraitUiHight * size;
  }

  ///横板设计稿  按宽度比例设置像素
  double getLanscapeHorizen(double size) {
    if (screenWidth == 0 || lanscapeUiWidth == 0) {
      initialize();
    }
    return screenWidth / lanscapeUiWidth * size;
  }

  ///横板设计稿  按高度比例设置像素
  double getLanscapeVertical(double size) {
    if (screenHeight == 0 || lanscapeUiHight == 0) {
      initialize();
    }
    return screenHeight / lanscapeUiHight * size;
  }
}
