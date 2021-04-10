import 'package:authen_provider/notifier/auth_notifier.dart';
import 'package:authen_provider/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            authNotifier.user != null ? authNotifier.user.displayName : "Feed"),
        actions: <Widget>[
          TextButton(
              onPressed: () => signout(authNotifier),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ))
        ],
      ),
      body: Center(
          child: Text(
        'Feed',
        style: TextStyle(fontSize: 48),
      )),
    );
  }
}
