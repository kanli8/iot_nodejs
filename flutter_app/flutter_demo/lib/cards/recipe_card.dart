import 'package:flutter/material.dart';
import 'package:smart_cook/models/my_recipes.dart';
import 'package:smart_cook/screens/recipe_details_screen.dart';
import 'package:smart_cook/component/shimmer/shimmer_loading.dart';
import 'package:smart_cook/main.dart';
import 'package:smart_cook/sql/appwirte/storage.dart';
import 'package:smart_cook/theme/MySize.dart';

class RecipeCard extends StatelessWidget {
  final MyRecipe recipe;
  final bool isLoading;
  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RecipeDetailsScreen.routeName,
            arguments: recipe);
      },
      child: Container(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(13.0),
          // ),
          color: Colors.white.withOpacity(0),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13.0),
                    child: getRecipesImagePreview(
                        recipe.imagePath, (width * 0.40).toInt(), 50),
                  ),
                  //favorite icon
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(13.0),
                        ),
                      ),
                      child: const Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
          // Stack(
          //   children:[
          //     ClipRRect(
          //         borderRadius: BorderRadius.circular(13.0),
          //         child: getRecipesImagePreview(recipe.imagePath,(width*0.55).toInt(),50),
          //     ),
          //     Column(
          //       crossAxisAlignment:CrossAxisAlignment.end,

          //       children:[
          //             SizedBox(
          //               width:MySize.indexCardWidth
          //             ),
          //             Padding(padding: EdgeInsets.only(right: 10,top: 10),
          //             child:
          //             Container(
          //                 alignment: Alignment.centerRight,
          //                 decoration:BoxDecoration(
          //                   borderRadius: BorderRadius.circular(10),
          //                   color: Theme.of(context).shadowColor,

          //                 ),
          //                 height: 40,

          //                 child: Icon(
          //                   Icons.bookmark_border,
          //                   color: Theme.of(context).primaryColor,
          //                   size:40
          //                 )

          //               )),

          //         Text(recipe.title)
          //       ]
          //     )
          //     ,

          //   ]
          // )

          ),
    );
  }
}
