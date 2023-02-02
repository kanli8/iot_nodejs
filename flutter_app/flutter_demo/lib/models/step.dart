
class Step {
  final String id;
  final String title;
  final String desc;
  final int type ;
  final Map<String,dynamic> params ;
  


  const Step( {
    required this.id,
    required this.title,
    required this.desc,
    required this.type,
    
    required this.params
  });
}
