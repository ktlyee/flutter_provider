import 'package:authen_provider/model/food.dart';
import 'package:authen_provider/notifier/food_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(foodNotifier.currentFood.name),
      ),
      body: Center(
          child: Container(
        child: Column(children: <Widget>[
          Image.network(foodNotifier.currentFood.image),
          SizedBox(height: 32),
          Text(
            foodNotifier.currentFood.name,
            style: TextStyle(fontSize: 30),
          ),
          Text(
            foodNotifier.currentFood.category,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(8),
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            children: foodNotifier.currentFood.subIngredients
                .map((ingredient) => Card(
                      color: Colors.black54,
                      child: Center(
                          child: Text(ingredient,
                              style: TextStyle(color: Colors.white))),
                    ))
                .toList(),
          )
        ]),
      )),
    );
  }
}
