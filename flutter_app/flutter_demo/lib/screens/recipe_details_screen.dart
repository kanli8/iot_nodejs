import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_cook/models/device_status.dart';
import 'package:smart_cook/models/my_recipes.dart';
import 'package:smart_cook/screens/recipe_runner_screen.dart';
import 'package:smart_cook/sql/appwirte/storage.dart';
import 'package:smart_cook/theme/MySize.dart';

class RecipeDetailsScreen extends StatefulWidget {
  static const routeName = '/recipe-details';

  final RouteSettings settings;

  const RecipeDetailsScreen({
    Key? key,
    required this.settings,
  }) : super(key: key);

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen>
    with SingleTickerProviderStateMixin {
  late MyRecipe _mr;

  DeviceStatus deviceStatus = DeviceStatus.getInstance();

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    _mr = widget.settings.arguments as MyRecipe;
  }

  Widget _getImages(String fileId) {
    return getRecipesImagePreview(fileId, MySize.width.toInt(), 100);
    //if wg is image, get image width and height
  }

  void _startCook() {
    Navigator.of(context).pushNamed(
      RecipeRunnerScreen.routeName,
      arguments: _mr,
    );
  }

  Widget _ingredientsView(List<dynamic> ingredients) {
    List<Widget> list = [];

    int heightCount = ingredients.length ~/ 3;

    if (ingredients.length % 3 != 0) {
      heightCount = heightCount + 1;
    }

    double height = heightCount * MySize.width * 0.96 / 3;

    for (int i = 0; i < ingredients.length; i++) {
      Map<String, dynamic> ingredient = jsonDecode(ingredients[i]);
      list.add(Card(
        // padding: const EdgeInsets.all(8),
        color: MySize.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getIngredientsPreview(ingredient['image'], 60, 100),
            const SizedBox(
              height: 5,
            ),
            Text(
              ingredient['desc'],
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ));
    }

    return SizedBox(
      height: height,
      child: GridView.count(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
              left: MySize.width * 0.02, right: MySize.width * 0.02),
          crossAxisSpacing: 0.5,
          mainAxisSpacing: 0.5,
          crossAxisCount: 3,
          children: list),
    );
  }

  Widget _stepView(List<dynamic> steps) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        // This Builder is needed to provide a BuildContext that is
        // "inside" the NestedScrollView, so that
        // sliverOverlapAbsorberHandleFor() can find the
        // NestedScrollView.
        builder: (BuildContext context) {
          return CustomScrollView(
            // The "controller" and "primary" members should be left
            // unset, so that the NestedScrollView can control this
            // inner scroll view.
            // If the "controller" property is set, then this scroll
            // view will not be associated with the NestedScrollView.
            // The PageStorageKey should be unique to this ScrollView;
            // it allows the list to remember its scroll position when
            // the tab view is not on the screen.
            key: const PageStorageKey<String>('step'),
            slivers: <Widget>[
              SliverOverlapInjector(
                // This is the flip side of the SliverOverlapAbsorber
                // above.
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                // In this example, the inner scroll view has
                // fixed-height list items, hence the use of
                // SliverFixedExtentList. However, one could use any
                // sliver widget here, e.g. SliverList or SliverGrid.
                sliver: SliverFixedExtentList(
                  // The items in this example are fixed to 48 pixels
                  // high. This matches the Material Design spec for
                  // ListTile widgets.
                  itemExtent: 60.0,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      // This builder is called for each child.
                      // In this example, we just number each list item.
                      Map<String, dynamic> step = jsonDecode(steps[index]);
                      return Container(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 1, bottom: 1), //.all(8),
                          child: Card(
                              child: Row(children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 12, bottom: 12),
                              child: Center(
                                  child: Text(index.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color.fromRGBO(242, 137, 79, 1),
                                        fontSize: 23,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(step['name'].toString()),
                                Text(step['duration'].toString() + ' min'),
                              ],
                            )
                          ])));
                    },
                    // The childCount of the SliverChildBuilderDelegate
                    // specifies how many children this inner list
                    // has. In this example, each tab has a list of
                    // exactly 30 items, but this is arbitrary.
                    childCount: steps.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _featureItem(IconData icon, String name, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 35,
          color: MySize.iconColor,
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: MySize.recipesDetailFeatureNameStyle),
            Text(value, style: MySize.recipesDetailFeatureValueStyle),
          ],
        )
      ],
    );
  }

  Widget _overviewView() {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        // This Builder is needed to provide a BuildContext that is
        // "inside" the NestedScrollView, so that
        // sliverOverlapAbsorberHandleFor() can find the
        // NestedScrollView.
        builder: (BuildContext context) {
          return CustomScrollView(
            // The "controller" and "primary" members should be left
            // unset, so that the NestedScrollView can control this
            // inner scroll view.
            // If the "controller" property is set, then this scroll
            // view will not be associated with the NestedScrollView.
            // The PageStorageKey should be unique to this ScrollView;
            // it allows the list to remember its scroll position when
            // the tab view is not on the screen.
            key: const PageStorageKey<String>('overview'),
            slivers: <Widget>[
              SliverOverlapInjector(
                // This is the flip side of the SliverOverlapAbsorber
                // above.
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                // In this example, the inner scroll view has
                // fixed-height list items, hence the use of
                // SliverFixedExtentList. However, one could use any
                // sliver widget here, e.g. SliverList or SliverGrid.
                sliver: SliverFixedExtentList(
                  // The items in this example are fixed to 48 pixels
                  // high. This matches the Material Design spec for
                  // ListTile widgets.
                  itemExtent: 250.0,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      // This builder is called for each child.
                      // In this example, we just number each list item.
                      return Container(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: Text(_mr.desc),
                            ),
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _featureItem(
                                        Icons.auto_awesome_mosaic_outlined,
                                        tr('Meal_Category'),
                                        'Main Dishes'),
                                    _featureItem(Icons.access_time,
                                        tr('Cook_Time'), '1 hr 14 min'),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _featureItem(Icons.group_work_outlined,
                                        tr('serving'), '4'),
                                    _featureItem(Icons.leaderboard_outlined,
                                        tr('Level'), 'Beginner'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    // The childCount of the SliverChildBuilderDelegate
                    // specifies how many children this inner list
                    // has. In this example, each tab has a list of
                    // exactly 30 items, but this is arbitrary.
                    childCount: 1,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _tabBars() {
    List<Widget> list = [];
    list.add(Tab(
      text: tr('OVERVIEW'),
    ));
    list.add(Tab(
      text: tr('INGREDIENTS'),
    ));
    list.add(Tab(
      text: tr('STEPS & est.time'),
    ));

    return list;
  }

  List<Widget> _tabViews() {
    List<Widget> list = [];
    list.add(_overviewView());
    list.add(_ingredientsView(_mr.ingredients));
    list.add(_stepView(_mr.steps));

    return list;
  }

  ///Bug not show ShapeDecoration
  Widget _detail() {
    return DefaultTabController(
      length: 3, // This is the number of tabs.
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                // This widget takes the overlapping behavior of the SliverAppBar,
                // and redirects it to the SliverOverlapInjector below. If it is
                // missing, then it is possible for the nested "inner" scroll view
                // below to end up under the SliverAppBar even when the inner
                // scroll view thinks it has not been scrolled.
                // This is not necessary if the "headerSliverBuilder" only builds
                // widgets that do not overlap the next sliver.
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: Text(_mr.title), // This is the title in the app bar.

                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite),
                      color: Theme.of(context).canvasColor,
                      iconSize: 30,
                    ),
                  ],
                  automaticallyImplyLeading: true,
                  expandedHeight: MySize.width * 0.92,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _getImages(_mr.imagePath),
                  ),
                  // The "forceElevated" property causes the SliverAppBar to show
                  // a shadow. The "innerBoxIsScrolled" parameter is true when the
                  // inner scroll view is scrolled beyond its "zero" point, i.e.
                  // when it appears to be scrolled below the SliverAppBar.
                  // Without this, there are cases where the shadow would appear
                  // or not appear inappropriately, because the SliverAppBar is
                  // not actually aware of the precise position of the inner
                  // scroll views.
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    // These are the widgets to put in each tab in the tab bar.
                    tabs: _tabBars(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: _tabViews(),
          ),
        ),
      ),
    );
  } //_detail

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
        minimumSize: Size(MySize.startButtonLength, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        elevation: 0);

    return Scaffold(
      body: _detail(),
      bottomNavigationBar: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: _startCook,
                    style: raisedButtonStyle,
                    child: const Text('start cook ')),
              ))
        ],
      ),
    );
  }
}
