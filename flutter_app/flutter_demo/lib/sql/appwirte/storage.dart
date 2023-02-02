import 'dart:io';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cook/sql/appwirte/client.dart';
import 'package:uuid/uuid.dart';

const deviceImgBucketId = '63361b4c4012ce4ffe2b';

Future<void> uploadImg(
    {required String imgBucketId,
    required void Function(Image image) onChooseImage,
    required void Function() onLoading,
    required void Function(String uuid) onSuccess,
    required void Function(String errMsg) onError}) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    onChooseImage(Image.file(File(image.path)));
    Storage storage = Storage(client);

    String uuid = const Uuid().v4();

    Future result = storage.createFile(
        bucketId: imgBucketId,
        fileId: uuid,
        file: InputFile(path: image.path),
        read: ['user:$userId'],
        write: ["user:$userId"]);

    result.then((response) {
      onSuccess(uuid);
    }).catchError((error) {
      onError(error.toString());
    });
  } else {
    onError('user cancle');
  }
}

void addRecipesImages(
    {required void Function(Image image) onChooseImage,
    required void Function() onLoading,
    required void Function(String uuid) onSuccess,
    required void Function(String errMsg) onError}) async {
  uploadImg(
      imgBucketId: rcpImgBucketId,
      onChooseImage: onChooseImage,
      onLoading: onLoading,
      onSuccess: onSuccess,
      onError: onError);
}

Widget getRecipesImagePreviewAndGetImageSize(String fileId, int height,
    int quality, Function(double w, double h) imageSize) {
  Storage storage = Storage(client);

  return FutureBuilder(
    future: storage.getFilePreview(
        bucketId: rcpImgBucketId,
        fileId: fileId,
        height: height,
        quality:
            quality), //works for both public file and private file, for private files you need to be logged in
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Uint8List bytes = snapshot.data as Uint8List;
        Image image = Image.memory(bytes);
        imageSize(image.width ?? 0, image.height ?? 0);
        return image;
      } else {
        return CircularProgressIndicator();
      }
      // return snapshot.hasData && snapshot.data != null
      //     ? Image.memory(
      //         snapshot.data as Uint8List,
      //       )
      //     : const CircularProgressIndicator();
    },
  );
}

Widget getRecipesImagePreview(String fileId, int height, int quality) {
  Storage storage = Storage(client);

  return FutureBuilder(
    future: storage.getFilePreview(
        bucketId: rcpImgBucketId,
        fileId: fileId,
        height: height,
        quality:
            quality), //works for both public file and private file, for private files you need to be logged in
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      }
      if (snapshot.hasData && snapshot.data != null) {
        Image image = Image.memory(
          snapshot.data as Uint8List,
        );

        //get image size
        image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo info, bool _) {
              print(info.image.width);
              print(info.image.height);
            },
          ),
        );
        return image;
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}

Widget getIngredientsPreview(String fileId, int height, int quality) {
  Storage storage = Storage(client);

  return FutureBuilder(
    future: storage.getFilePreview(
        bucketId: ingredientsImgBucketId,
        fileId: fileId,
        height: height,
        quality:
            quality), //works for both public file and private file, for private files you need to be logged in
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      }
      return snapshot.hasData && snapshot.data != null
          ? Image.memory(
              snapshot.data as Uint8List,
            )
          : const CircularProgressIndicator();
    },
  );
}

Widget getDeviceImgPreview(String fileId, int height, int quality) {
  Storage storage = Storage(client);

  return FutureBuilder(
    future: storage.getFilePreview(
        bucketId: deviceImgBucketId,
        fileId: fileId,
        height: height,
        quality:
            quality), //works for both public file and private file, for private files you need to be logged in
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      }
      return snapshot.hasData && snapshot.data != null
          ? Image.memory(
              snapshot.data as Uint8List,
            )
          : const CircularProgressIndicator();
    },
  );
}
