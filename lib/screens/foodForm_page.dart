import 'dart:io';

import 'package:authen_provider/model/food.dart';
import 'package:authen_provider/notifier/food_notifier.dart';
import 'package:authen_provider/services/food_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FoodFormPage extends StatefulWidget {
  final bool isUpdating;
  FoodFormPage({@required this.isUpdating});

  @override
  _FoodFormPageState createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List _subIngredients = [];
  Food _currentFood;
  String _imageUrl;
  File _imageFile;
  TextEditingController subIngredientController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);

    if (foodNotifier.currentFood != null) {
      _currentFood = foodNotifier.currentFood;
    } else {
      _currentFood = Food();
    }

    _subIngredients.addAll(_currentFood.subIngredients);
    _imageUrl = _currentFood.image;
  }

  Widget _showImage() {
    if (_imageUrl == null && _imageFile == null) {
      return Text('image placeholder');
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(_imageFile, fit: BoxFit.cover, height: 250),
          TextButton(
              onPressed: () => _getLocalImage(),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(16), backgroundColor: Colors.black54),
              child: Text('Change image',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400)))
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(_imageUrl, fit: BoxFit.cover, height: 250),
          TextButton(
              onPressed: () => _getLocalImage(),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(16), backgroundColor: Colors.black54),
              child: Text('Change image',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400)))
        ],
      );
    }
  }

  _getLocalImage() async {
    PickedFile imageFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      initialValue: _currentFood.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Name must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFood.name = value;
      },
    );
  }

  Widget _buildCategoryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Category'),
      initialValue: _currentFood.category,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Category is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Category must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFood.category = value;
      },
    );
  }

  _buildSubIngredientsField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: subIngredientController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Sub Ingredient'),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  _onFoodUploaded(Food food) {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    foodNotifier.addFood(food);
    Navigator.pop(context);
  }

  _addSubIngredient(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _subIngredients.add(text);
      });
      subIngredientController.clear();
    }
  }

  _saveFood() {
    print('saveFood Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    print('form saved');

    _currentFood.subIngredients = _subIngredients;

    updateFoodAndImage(
        _currentFood, widget.isUpdating, _imageFile, _onFoodUploaded);

    print("name: ${_currentFood.name}");
    print("category: ${_currentFood.category}");
    print("subingredients: ${_currentFood.subIngredients}");
    print("_imageFile: ${_imageFile.toString()}");
    print("_imageUrl: $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('FoodForm'),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: <Widget>[
                  _showImage(),
                  SizedBox(height: 16),
                  Text(
                    widget.isUpdating ? "Edit Food" : "Create Food",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 16),
                  _imageFile == null && _imageUrl == null
                      ? ButtonTheme(
                          child: ElevatedButton(
                            onPressed: () => _getLocalImage(),
                            child: Text(
                              "Add image",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : SizedBox(height: 0),
                  _buildNameField(),
                  _buildCategoryField(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildSubIngredientsField(),
                      ButtonTheme(
                          child: ElevatedButton(
                        child:
                            Text('Add', style: TextStyle(color: Colors.white)),
                        onPressed: () =>
                            _addSubIngredient(subIngredientController.text),
                      ))
                    ],
                  ),
                  SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(8),
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    children: _subIngredients
                        .map((ingredient) => Card(
                              color: Colors.black54,
                              child: Center(
                                  child: Text(ingredient,
                                      style: TextStyle(color: Colors.white))),
                            ))
                        .toList(),
                  )
                ],
              ),
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _saveFood();
          },
          child: Icon(Icons.save),
          foregroundColor: Colors.white,
        ));
  }
}
