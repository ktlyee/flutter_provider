import 'dart:io';

import 'package:authen_provider/model/food.dart';
import 'package:authen_provider/notifier/food_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

getFoods(FoodNotifier foodNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Foods')
      .orderBy("createdAt", descending: true)
      .get();

  List<Food> _foodList = [];

  snapshot.docs.forEach((document) {
    Food food = Food.fromMap(document.data());
    _foodList.add(food);
  });

  foodNotifier.foodList = _foodList;
}

updateFoodAndImage(
    Food food, bool isUpdating, File localFile, Function foodUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uudid = Uuid().v4();

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('food/$uudid$fileExtension');

    await firebaseStorageRef.putFile(localFile).catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();

    print("download url: $url");
    _uploadFood(food, isUpdating, foodUploaded, imageUrl: url);
  } else {
    print("...skipping image upload");
    _uploadFood(food, isUpdating, foodUploaded);
  }
}

_uploadFood(Food food, bool isUpdating, Function foodUploaded,
    {String imageUrl}) async {
  CollectionReference foodRef = FirebaseFirestore.instance.collection('Foods');

  if (imageUrl != null) {
    food.image = imageUrl;
  }

  if (isUpdating) {
    food.updatedAt = Timestamp.now();

    await foodRef.doc(food.id).update(food.toMap());

    foodUploaded(food);
    print("updated food with id: ${food.id}");
  } else {
    food.createdAt = Timestamp.now();

    DocumentReference documentRef = await foodRef.add(food.toMap());

    food.id = documentRef.id;

    print("uploaded food successfully: ${food.toString}");

    await documentRef.set(food.toMap(), SetOptions(merge: true));

    foodUploaded(food);
  }
}

deleteFood(Food food, Function foodDeleted) async {
  if (food.image != null) {
    Reference storageRef =
        await FirebaseStorage.instance.refFromURL(food.image);

    // print(storageRef.path);

    await storageRef.delete();

    print('image deleted');
  }

  await FirebaseFirestore.instance.collection('Foods').doc(food.id).delete();
  foodDeleted(food);
}
