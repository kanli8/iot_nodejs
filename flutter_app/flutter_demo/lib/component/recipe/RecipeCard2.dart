import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:smart_cook/constant/font_name_constants.dart';
import 'package:smart_cook/constant/image_path_constants.dart';
import 'package:smart_cook/constant/url_constant.dart';
import 'package:smart_cook/theme/default_color.dart';
import 'package:smart_cook/util/screen_adapt.dart';

class RecipeCard2 extends StatelessWidget {
  ///首页菜谱卡片

  final void Function() onPressed;
  final String name;
  final String difficult;
  final String time;
  final String img;
  final String score;
  final bool isOffLine; //是否使用本地图片
  final String recipeId; //菜谱id，使用本地图片需要用到

  const RecipeCard2(
      {Key? key,
      required this.onPressed,
      required this.name,
      required this.difficult,
      required this.time,
      required this.img,
      required this.score,
      required this.isOffLine,
      required this.recipeId})
      : super(key: key);

  // name = 'Jamaican Style Cod With Pineapple Salsa';

  @override
  Widget build(BuildContext context) {
    double boxClipRadius = ScreenAdapt().getLanscapeVertical(10);
    double cardHeight = ScreenAdapt().getLanscapeVertical(263);
    double cardWidth = ScreenAdapt().getLanscapeVertical(267);
    double imgHeight = ScreenAdapt().getLanscapeVertical(150);
    double iconSize = ScreenAdapt().getLanscapeVertical(28);
    double scoreHeight = ScreenAdapt().getLanscapeVertical(36);
    double scoreWidth = ScreenAdapt().getLanscapeHorizen(75);
    double scoreMargin = ScreenAdapt().getLanscapeVertical(12);
    double scorePadding = ScreenAdapt().getLanscapeVertical(8);
    double scoreIconSize = ScreenAdapt().getLanscapeVertical(18);

    Color iconColor = DefaultColor.normalText;

    ///难度图标
    SvgPicture levelIcon = SvgPicture.asset(
      ImagePathConstants.cookingDifficulty,
      color: iconColor,
      width: iconSize,
      height: iconSize,
    );

    ///时间
    SvgPicture timeIcon = SvgPicture.asset(
      ImagePathConstants.cookingTime,
      color: iconColor,
      width: iconSize,
      height: iconSize,
    );
    ImageProvider defaultImage =
        AssetImage(ImagePathConstants.recipeImgDefault); //卡片默认图片
    ImageProvider imgProvider = defaultImage;

    if (img != null && img != "") {
      if (!isOffLine) {
        //在线图片
        String imgUrl = UrlConstant.getImageUrlPre + "/" + img;
        imgProvider = NetworkImage(imgUrl);
      } else {
        //本地图片
        String fileName = img;
        String filePath = '' + "/$recipeId/images/" + fileName;
        File imgFile = File(filePath);
        if (imgFile.existsSync()) {
          //图片存在
          imgProvider = FileImage(imgFile);
        }
      }
    }

    //评分图标
    Widget scoreContainer = ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(scoreWidth / 2)),
        child: Container(
          height: scoreHeight,
          width: scoreWidth,
          color: DefaultColor.recipeScoreBgLandscape,
          padding: EdgeInsets.only(left: scorePadding, right: scorePadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: ScreenAdapt().getLanscapeVertical(36),
                child: Center(
                  child: Text(
                    score,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: DefaultColor.normalText,
                        fontFamily: FontFamily.Avenir,
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenAdapt().getLanscapeVertical(24)),
                  ),
                ),
              ),
              //评分
              SvgPicture.asset(
                ImagePathConstants.recipeScore,
                width: scoreIconSize,
                height: scoreIconSize,
                fit: BoxFit.cover,
              )
            ],
          ),
        ));

    //食谱图片以及评分
    Widget imgAndScore = SizedBox(
      height: imgHeight,
      width: cardWidth,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // recipeImg, //图片
          Image(
            image: imgProvider,
            fit: BoxFit.cover,
            height: imgHeight,
            width: cardWidth,
            errorBuilder: (context, error, stackTrace) {
              return Image(
                image: defaultImage,
                fit: BoxFit.cover,
                height: imgHeight,
                width: cardWidth,
              );
            },
          ), //图片
          Positioned(
              right: scoreMargin,
              bottom: scoreMargin,
              child: score != '' ? scoreContainer : Container())
        ],
      ),
    );

    // TODO: implement build
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(boxClipRadius)),
      child: Container(
        height: cardHeight,
        width: cardWidth,
        color: DefaultColor.midParamsBoxBgLandscape,
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ), //取消按钮自带内边距与水波颜色
          onPressed: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imgAndScore,
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(
                    top: ScreenAdapt().getLanscapeVertical(6),
                    left: ScreenAdapt().getLanscapeVertical(12),
                    right: ScreenAdapt().getLanscapeVertical(12),
                    bottom: ScreenAdapt().getLanscapeVertical(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //菜谱名
                      Expanded(
                        child: Center(
                          child: Builder(
                            builder: (BuildContext context) {
                              return RichText(
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                text: HTML.toTextSpan(
                                  context,
                                  name ?? "",
                                  defaultTextStyle: TextStyle(
                                    fontFamily: FontFamily.Avenir,
                                    color: DefaultColor.normalText,
                                    fontWeight: FontWeight.w900,
                                    height: 34 / 24,
                                    fontSize:
                                        ScreenAdapt().getLanscapeVertical(24),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: ScreenAdapt().getLanscapeVertical(27),
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Positioned(
                                left: 0,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    timeIcon, //时间图标
                                    // Container(width: ScreenAdapt().getLanscapeHorizen(5)),
                                    //时间文字
                                    Text(
                                      time,
                                      style: TextStyle(
                                          color: DefaultColor.activeText,
                                          fontFamily: FontFamily.Avenir,
                                          fontWeight: FontWeight.w900,
                                          fontSize: ScreenAdapt()
                                              .getLanscapeVertical(24)),
                                    ),
                                  ],
                                )),
                            Positioned(
                                right: 0,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    levelIcon, //难度图标
                                    // Container(width: ScreenAdapt().getLanscapeHorizen(5)),
                                    //难度文字
                                    Text(
                                      difficult,
                                      style: TextStyle(
                                          color: DefaultColor.activeText,
                                          fontFamily: FontFamily.Avenir,
                                          fontWeight: FontWeight.w900,
                                          fontSize: ScreenAdapt()
                                              .getLanscapeVertical(24)),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
