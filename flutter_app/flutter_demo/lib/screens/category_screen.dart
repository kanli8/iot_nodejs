import 'dart:typed_data';

import 'package:appwrite/models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_cook/component/awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:smart_cook/models/my_recipes.dart';

import 'package:smart_cook/cards/recipe_card.dart';
import 'package:smart_cook/component/shimmer/shimmer.dart';
import 'package:smart_cook/screens/preset_list_screen.dart';
import 'package:smart_cook/sql/appwirte/database.dart';
import 'package:smart_cook/theme/MySize.dart';

const _shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category';
  final void Function(String name, Object args) gotoPageAndArgs;
  const CategoryScreen({Key? key, required this.gotoPageAndArgs})
      : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _isLoading = true;
  bool _isError = false;
  String _errorMsg = '';
  final Map<String, List<MyRecipe>> _recipeMap = {};

  late Uint8List imgsData = Uint8List.fromList([]);
  late DocumentList recipes;

  @override
  void initState() {
    super.initState();
    _getList();
  }

  void _getList() {
    getRecipesShowIndexList(onLoading: () {
      setState(() {
        _isLoading = true;
        _isError = false;
      });
    }, onData: (recipeList) {
      setState(() {
        _isLoading = false;
        //to map
        for (int i = 0; i < recipeList.length; i++) {
          if (_recipeMap[recipeList[i].cata] == null) {
            List<MyRecipe> list = [];
            list.add(recipeList[i]);
            _recipeMap[recipeList[i].cata] = list;
          } else {
            _recipeMap[recipeList[i].cata]?.add(recipeList[i]);
          }
        }
      });
    }, onError: (errMsg) {
      setState(() {
        _isLoading = false;
        _isError = true;
        _errorMsg = errMsg;
      });
    });
  }

  Widget _getNullList() {
    List<Widget> list = [];
    for (int i = 0; i < 10; i++) {
      list.add(
          RecipeCard(recipe: MyRecipe.getNullEntity(), isLoading: _isLoading));
    }

    return ListView(children: list);
  }

  Widget _recipeList(context, List<MyRecipe> value) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MySize.indexCardHeight,
        width: MySize.indexCardWidth,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: value.length,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(right: 10),
            child: RecipeCard(recipe: value[index], isLoading: _isLoading),
          ),
        ),
      ),
    );
  }

  List<Widget> _cataList() {
    List<Widget> list = [];

    _recipeMap.forEach((key, value) {
      list.add(SliverPadding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
            [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    key,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //see all
                  TextButton(
                    onPressed: () {
                      // widget.gotoPageAndArgs(PresetListScreen.routeName,
                      //     {'cata': key, 'title': key});
                    },
                    child: Row(children: [
                      Text(
                        tr('see_all'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_double_arrow_right,
                        size: 20,
                      )
                    ]),
                  ),
                ],
              )
            ],
          ),
        ),
      ));

      list.add(_recipeList(context, value));
    });

    return list;
  }

  Widget _getRecipeCardsList() {
    //cata deal
    return CustomScrollView(
      slivers: _cataList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar _appBar = AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
            ),
            onPressed: () {
              AwesomeDrawerBar.of(context)!.toggle();
            },
          );
        },
      ),
      // title: SvgPicture.asset('assets/images/Logo.svg', fit: BoxFit.contain),
      title: Text(tr('Recipes')),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.tune_outlined,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.search,
          ),
          onPressed: () {},
        ),
      ],
      elevation: 0,
    );

    if (_isLoading) {
      return Scaffold(
          appBar: _appBar,
          body: Shimmer(
            linearGradient: _shimmerGradient,
            child: _getNullList(),
          ));
    }

    if (_isError) {
      return Scaffold(appBar: _appBar, body: Text(_errorMsg));
    }

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
        ),
        elevation: 0);

    return Scaffold(
        appBar: _appBar,
        body: _getRecipeCardsList(),
        bottomSheet: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, PresetListScreen.routeName, (route) => false);
                  },
                  style: raisedButtonStyle,
                  child: Text(tr('to_preset'))),
            )
          ],
        ));
  }
}
