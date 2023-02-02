

class MyRecipe {
  final int id;
  final String title;
  final String duration;
  final String servings;
  final String imagePath;
  final List<dynamic> ingredients;
  final String desc;
  final List<dynamic> steps;
  final List<dynamic> tags;
  final List<dynamic> features;
  final String cata ;
  const MyRecipe({
    required this.id,
    required this.title,
    required this.tags, 
    required this.desc,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.servings,
    required this.imagePath,
    required this.cata,
    required this.features,
    
  });

  //List<dynamic> to List<String>
  //final List<String> strs = numbers.map((e) => e.toString()).toList();

  MyRecipe.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        tags = map['tags'],
        desc = map['desc'],
        ingredients=map['ingredients'],
        steps=map['steps'],
        duration=map['duration'],
        servings=map['servings'],
        imagePath=map['imagePath'],
        cata=map['cata'],
        features=map['features']
        ;


  MyRecipe.getNullEntity()
      : id = 0,
        title = '',
        tags =[],
        desc ='',
        ingredients=[],
        steps=[],
        duration='',
        servings='',
        imagePath='',
        cata='',
        features=[];


  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {};
    map['id'] = id;
    map['title'] = title;
    map['tags']=tags;
    map['desc'] = desc;
    map['ingredients'] = ingredients;
    map['steps']= steps;
    map['duration']=duration;
    map['servings']=servings;
    map['imagePath']=imagePath;
    map['cata']=cata;
    return map;
  }

  @override
  String toString() {
    String str = id.toString() 
                  + ":::"+title +"||"
                  +duration+"|"+servings +"\n"
                  +imagePath  +"\n"
                  +desc
                  ;
    return str;
  }

}





