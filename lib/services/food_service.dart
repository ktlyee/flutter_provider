import 'package:authen_provider/model/food.dart';
import 'package:authen_provider/notifier/food_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
