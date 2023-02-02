import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class RecipeDetails extends StatelessWidget {
  final String title;
  final List<String> recipeInfo;

  const RecipeDetails({Key? key, 
    required this.title,
    required this.recipeInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            top: 5.0,
            bottom: 15.0,
          ),
          child: Text(
            title,
            style: kNormalTitleTextStyle,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: const Color(0x33FF5C4D),
          ),
          margin: const EdgeInsets.only(
            bottom: 15.0,
          ),
          padding: const EdgeInsets.only(
            top: 5.0,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.only(
                      bottom: recipeInfo.length - 1 == index ? 5.0 : 0.0,
                      left: 15.0,
                      right: 15.0,
                    ),
                    leading: title == 'Ingredients'
                        ? const CircleAvatar(
                            radius: 10.0,
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            child: Icon(
                              Icons.check,
                              size: 13.0,
                            ),
                          )
                        : Text(
                            'Step ${index + 1}',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    title: Text(
                      recipeInfo[index],
                      style: const TextStyle(
                        color: Color(0xBB000000),
                      ),
                    ),
                  ),
                  title != 'Cooking Instructions'
                      ? Container()
                      : recipeInfo.length - 1 == index
                          ? Container()
                          : const Divider(
                              thickness: 0.2,
                              color: Colors.black54,
                              indent: 15.0,
                              endIndent: 15.0,
                            ),
                ],
              );
            },
            itemCount: recipeInfo.length,
          ),
        ),
      ],
    );
  }
}
