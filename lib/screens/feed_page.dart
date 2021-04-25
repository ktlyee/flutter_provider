import 'package:authen_provider/model/food.dart';
import 'package:authen_provider/notifier/auth_notifier.dart';
import 'package:authen_provider/notifier/food_notifier.dart';
import 'package:authen_provider/screens/detail_page.dart';
import 'package:authen_provider/screens/foodForm_page.dart';
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
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    Future<void> _refreshList() async {
      getFoods(foodNotifier);
    }

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
        body: new RefreshIndicator(
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.network(
                      foodNotifier.foodList[index].image != null
                          ? foodNotifier.foodList[index].image
                          : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                      width: 100,
                      fit: BoxFit.fitWidth),
                  title: Text(foodNotifier.foodList[index].name),
                  subtitle: Text(foodNotifier.foodList[index].category),
                  onTap: () {
                    foodNotifier.currentFood = foodNotifier.foodList[index];
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => FoodDetailPage()));
                  },
                );
              },
              itemCount: foodNotifier.foodList.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.black,
                );
              }),
          onRefresh: _refreshList,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            foodNotifier.currentFood = null;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    FoodFormPage(isUpdating: false)));
          },
          child: Icon(Icons.add),
          foregroundColor: Colors.white,
        ));
  }
}
