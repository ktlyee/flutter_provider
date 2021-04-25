import 'package:authen_provider/model/food.dart';
import 'package:authen_provider/notifier/food_notifier.dart';
import 'package:authen_provider/screens/foodForm_page.dart';
import 'package:authen_provider/services/food_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class FoodDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    _onFoodDeleted(Food food) {
      Navigator.pop(context);
      foodNotifier.deleteFood(food);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(foodNotifier.currentFood.name),
        ),
        body: Center(
            child: Container(
          child: Column(children: <Widget>[
            Image.network(foodNotifier.currentFood.image != null
                ? foodNotifier.currentFood.image
                : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg'),
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
            Text(
              'Ingredients',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "button1",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        FoodFormPage(isUpdating: true)));
              },
              child: Icon(Icons.edit),
              foregroundColor: Colors.white,
            ),
            SizedBox(height: 20),
            FloatingActionButton(
                heroTag: "button2",
                onPressed: () =>
                    deleteFood(foodNotifier.currentFood, _onFoodDeleted),
                child: Icon(Icons.delete),
                foregroundColor: Colors.white,
                backgroundColor: Colors.red)
          ],
        ));
  }
}
