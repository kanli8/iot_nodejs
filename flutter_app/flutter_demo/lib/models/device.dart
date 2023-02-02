import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:smart_cook/sql/appwirte/client.dart';

const String dbDeviceCollectionId = '63353c31cf7c47823905';
const String dbUserDeviceCollectionId = '6305dd1f30ea754a2b25';

class Device {
  final int status;
  final String name;
  final String deviceImg;
  final String ownerUserId;
  final int deviceModelId;
  final String deviceId;

  Device({
    required this.status,
    required this.name,
    required this.deviceImg,
    required this.ownerUserId,
    required this.deviceModelId,
    required this.deviceId,
  });

  Device.fromMap(
    Map<String, dynamic> map,
  )   : status = map['status'],
        name = map['name'],
        deviceImg = map['device_img'],
        ownerUserId = map['owner_user_id'],
        deviceModelId = map['model_id'],
        deviceId = map['device_id'];

  static Future<Device> getDeviceByid(String id) async {
    final database = Databases(client, databaseId: databaseBssId);
    Document deviceDocument = await database.getDocument(
        collectionId: dbDeviceCollectionId, documentId: id);
    return Device.fromMap(deviceDocument.data);
  }

  //List<Device>
  static Future<void> getDeviceListByUserId({
    required void Function(List<Device> deviceList) onData,
    required void Function(String errMsg) onError,
    required void Function() onLoading,
  }) async {
    onLoading();
    try {
      final database = Databases(client, databaseId: databaseOssId);
      debugPrint('owner_user_id:$userId');
      DocumentList deviceFamilyList = await database.listDocuments(
          collectionId: dbUserDeviceCollectionId,
          queries: [Query.equal('owner_user_id', userId)]);
      List<Device> deviceList = [];
      debugPrint('deviceList:::' + deviceFamilyList.documents.toString());

      for (Document df in deviceFamilyList.documents) {
        String deviceId = df.data['device_id'];

        deviceList.add(Device.fromMap(df.data));
      }
      onData(deviceList);
    } catch (e) {
      onError(e.toString());
    }
  }
}
