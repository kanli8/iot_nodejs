import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_cook/models/device.dart';
import 'package:uuid/uuid.dart';

import '../sql/appwirte/client.dart';

const String dbFamilyCollectionId = '63085fae908b32733d3f';
const String dbUserFamilyCollectionId = '63085f9f85baf18ab66d';
const String dbDeviceFamilyCollectionId = '63086186adb68ca2efe5';

//no error deal
class Family {
  final String familyId;
  final String familyName;
  final String owner;
  final int lastUseTime;
  final List<Device> deviceList;

  static List<Family> cachedFamilyList = [];
  static Family? cacheFamily;

  const Family({
    required this.lastUseTime,
    required this.deviceList,
    required this.familyId,
    required this.familyName,
    required this.owner,
  });

  Family.getNullEntity()
      : lastUseTime = 0,
        deviceList = [],
        familyId = '',
        familyName = '',
        owner = '';

  static Future<void> getFamily(
      {required void Function() onLoading,
      required void Function() onData,
      required void Function(String errMsg) onError}) async {
    final database = Databases(client, databaseId: databaseBssId);
    onLoading();
    debugPrint('getFamily......');
    try {
      DocumentList userFamilyList = await database.listDocuments(
          collectionId: dbUserFamilyCollectionId,
          queries: [Query.equal('user_id', userId)]);
      int lastUseTime = 0;
      debugPrint('userFamilyList: ${userFamilyList.documents.length}');
      cachedFamilyList = [];
      Family? lastUseFamily;
      for (Document uf in userFamilyList.documents) {
        String familyId = uf.data['family_id'];
        Document familyInfo = await database.getDocument(
            collectionId: dbFamilyCollectionId, documentId: familyId);

        List<Device> deviceList2 = [];
        for (Document deviceDocument in userFamilyList.documents) {
          String deviceId = deviceDocument.data['device_id'];
          Device device = await Device.getDeviceByid(deviceId);
          deviceList2.add(device);
        }

        Family tmpFamily = Family(
          deviceList: deviceList2,
          familyId: familyId,
          familyName: familyInfo.data['name'],
          lastUseTime: uf.data['last_use_time'],
          owner: familyInfo.data['owner_user'],
        );

        if (tmpFamily.lastUseTime > lastUseTime) {
          lastUseFamily = tmpFamily;
        }
        cachedFamilyList.add(tmpFamily);
      }

      cacheFamily = lastUseFamily;
      onData();
    } catch (err) {
      onError(err.toString());
    }
  }

  //create new family
  static Future<void> createFamily(String name) async {
    String familyId = Uuid().v4();
    final database = Databases(client, databaseId: databaseBssId);
    try {
      await database.createDocument(
          collectionId: dbFamilyCollectionId,
          documentId: familyId,
          data: {
            'name': name,
            'owner_user': userId,
          },
          read: [
            'user:$userId'
          ],
          write: [
            'user:$userId'
          ]);
      //update user family default value
      //create user family document
      await database.createDocument(
          collectionId: dbUserFamilyCollectionId,
          documentId: const Uuid().v4(),
          data: {
            'user_id': userId,
            'last_use_time': DateTime.now().millisecondsSinceEpoch,
            'family_id': familyId
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
