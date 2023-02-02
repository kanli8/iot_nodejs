import 'package:smart_cook/models/my_recipes.dart';
import 'package:smart_cook/models/tag.dart';

const testTags=  [
  Tag(
    id: 1, 
    title: "tag1", 
    imagePath: ""),
  
  Tag(
    id: 2, 
    title: "tag2", 
    imagePath: ""),


] ;



const testRecipes=  [
  MyRecipe(
    id: 1, 
    title: "title111", 
    tags: [""], 
    duration: "900", 
    servings: "5 serv", 
    imagePath: "none", 
    ingredients: [""], 
    desc: "<h1 style=\"text-align: center;\">What is Rich Text Editor?</h1><p><a href=\"https://richtexteditor.com\">Rich Text Editor</a> is a full-featured Javascript WYSIWYG HTML editor. It enables content contributors easily create and publish HTML anywhere: on the desktop and on mobile.</p><p style=\"text-align: center;\"><img src=\"/images/editor-image.png\" alt=\"Editor image\" /></p><h4>Key features:</h4><ul><li>Built-in image handling &amp; storage</li><li>File drag &amp; drop</li><li>Table Insert</li><li>Provides a fully customizable toolbar</li<li>Paste from Word, Excel and Google Docs</li><li>Mobile Device Support</li></ul>", 
    steps: [""],
    cata: '', 
    features: [],

    )

] ;