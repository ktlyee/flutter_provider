import 'package:authen_provider/model/food.dart';
import 'package:authen_provider/notifier/auth_notifier.dart';
import 'package:authen_provider/notifier/food_notifier.dart';
import 'package:authen_provider/services/auth_service.dart';
import 'package:authen_provider/services/food_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedPage> {
  @override
  void initState() {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    getFoods(foodNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(authNotifier.user != null
              ? authNotifier.user.displayName
              : "Feed"),
          actions: <Widget>[
            TextButton(
                onPressed: () => signout(authNotifier),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ))
          ],
        ),
        body: Container(child:
            Consumer<FoodNotifier>(builder: (context, foodNotifier, child) {
          return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.network(foodNotifier.foodList[index].image,
                      width: 100, fit: BoxFit.fitWidth),
                  title: Text(foodNotifier.foodList[index].name),
                  subtitle: Text(foodNotifier.foodList[index].category),
                );
              },
              itemCount: foodNotifier.foodList.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.black,
                );
              });
        })));
  }
}
