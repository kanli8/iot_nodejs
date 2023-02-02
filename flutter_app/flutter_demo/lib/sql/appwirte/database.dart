import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_cook/models/my_recipes.dart';
import 'package:smart_cook/sql/appwirte/client.dart';
import 'package:uuid/uuid.dart';

const dbUserDevice = '6305dd1f30ea754a2b25';
const dbDeviceModel = '6336f8414b9f81c4a4eb';

void getRecipesShowIndexList(
    {required void Function() onLoading,
    required void Function(List<MyRecipe> recipeList) onData,
    required void Function(String errMsg) onError}) {
  List<MyRecipe> recipeList = [];
  Databases databases =
      Databases(client, databaseId: databaseBssId); // 'client' comes from setup
  Future<DocumentList> result = databases.listDocuments(
      collectionId: recipesCollectionId,
      queries: [Query.equal('showIndex', true)]);

  onLoading();

  result.then((response) {
    recipeList = [];
    for (var element in response.documents) {
      debugPrint(element.data.toString());
      recipeList.add(MyRecipe.fromMap(element.data));
    }
    onData(recipeList);
  }).catchError((error) {
    onError(error.toString());
  });
}

void getCataRecipesList(
    {required String cata,
    required void Function() onLoading,
    required void Function(List<MyRecipe> recipeList) onData,
    required void Function(String errMsg) onError}) {
  List<MyRecipe> recipeList = [];
  Databases databases =
      Databases(client, databaseId: databaseBssId); // 'client' comes from setup
  Future<DocumentList> result = databases.listDocuments(
      collectionId: recipesCollectionId, queries: [Query.equal('cata', cata)]);

  onLoading();

  result.then((response) {
    recipeList = [];
    for (var element in response.documents) {
      debugPrint(element.data.toString());
      recipeList.add(MyRecipe.fromMap(element.data));
    }
    onData(recipeList);
  }).catchError((error) {
    onError(error.toString());
  });
}

void getDefaultFamilyId(
    {required void Function() onLoading,
    required void Function(List<MyRecipe> recipeList) onData,
    required void Function(String errMsg) onError}) {
  //
  Databases databases = Databases(client, databaseId: databaseBssId);
  Future<DocumentList> result =
      databases.listDocuments(collectionId: dbUserFamily, queries: [
    Query.equal('user_id', userId),
    Query.equal('is_default ', true),
  ]);

  result.then((response) {
    if (response.documents.isEmpty) {
      //
      // createNewFamily(onData: (List<MyRecipe> recipeList) {  });
    }

    for (var element in response.documents) {
      debugPrint(element.data.toString());
    }
    // onData(recipeList);
  }).catchError((error) {
    onError(error.toString());
  });
}

void changeDefaultFamilyId() {}

void createNewFamily(
    {required void Function() onLoading,
    required void Function(List<MyRecipe> recipeList) onData,
    required void Function(String errMsg) onError}) {
  //
  Databases databases = Databases(client, databaseId: databaseBssId);
  String familyId = const Uuid().v4();
  onLoading();
  Future<Document> result2 = databases
      .createDocument(collectionId: dbFamily, documentId: familyId, data: {
    'name': 'xxxx family',
    'owner_user': userId,
    'device_ids': [],
  }, read: [
    '*'
  ], write: [
    '*'
  ]);

  result2.then((response) {
    Future<Document> result = databases.createDocument(
        collectionId: dbUserFamily,
        documentId: const Uuid().v4(),
        data: {
          'user_id': userId,
          'family_id': familyId,
          'is_default': true,
        },
        read: [
          '*'
        ],
        write: [
          '*'
        ]);

    result.then((response) {
      debugPrint(response.data.toString());
      // onData(recipeList);
    }).catchError((error) {
      onError(error.toString());
    });
  }).catchError((error) {
    onError(error.toString());
  });
}

void addnewUserDevice(String deviceId, int model,
    {required void Function() onLoading,
    required void Function() onSuccess,
    required void Function(String errMsg) onError}) async {
  //
  Databases databases = Databases(client, databaseId: databaseOssId);
  onLoading();

  //get device model
  DocumentList documentList = await databases.listDocuments(
      collectionId: dbDeviceModel, queries: [Query.equal('model_id', model)]);

  if (documentList.documents.isEmpty) {
    onError('model not found');
    return;
  }

  String modelName = documentList.documents[0].data['model_name'];
  String modelImage = documentList.documents[0].data['model_img'];

  Future<Document> result = databases.createDocument(
    collectionId: dbUserDevice,
    documentId: const Uuid().v4(),
    data: {
      'status': 0,
      'name': modelName,
      'device_img': modelImage,
      'owner_user_id': userId,
      'model_id': model,
      'device_id': deviceId,
    },
    write: ['user:$userId'],
    read: ['user:$userId'],
  );

  result.then((response) {
    debugPrint(response.data.toString());
    // onData(recipeList);
    onSuccess();
  }).catchError((error) {
    onError(error.toString());
  });
}
