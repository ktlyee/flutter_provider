import 'package:authen_provider/model/customer.dart';
import 'package:authen_provider/notifier/auth_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

login(Customer customer, AuthNotifier authNotifier) async {
  UserCredential authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(
          email: customer.email, password: customer.password)
      .catchError((error) => print(error));

  if (authResult != null) {
    User firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

register(Customer customer, AuthNotifier authNotifier) async {
  UserCredential authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: customer.email, password: customer.password)
      .catchError((error) => print(error));

  if (authResult != null) {
    User firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateProfile(displayName: customer.displayName);
      await firebaseUser.reload();
      print("Sign up: $firebaseUser");
      // await FirebaseAuth.instance.currentUser
      //     .updateProfile(displayName: customer.displayName);
      // print("Sign up: $firebaseUser");
      User currentUser = await FirebaseAuth.instance.currentUser;
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  User firebaseUser = await FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}
