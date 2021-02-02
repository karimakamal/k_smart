import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_smart/login.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

message( String msg ){
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController username = new TextEditingController();
  TextEditingController users_no = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController password_confirm = new TextEditingController();
  final _key = GlobalKey<FormState>();

  void register() async{
    if(_key.currentState.validate())
    {
      if(password.text == password_confirm.text){
        final response = await http.post(
          "https://easesp8266.000webhostapp.com/file.php",
          body: {
            "userid": username.text,
            "type": '1',
            "usersno": users_no.text,
            "pass": password.text,
          },
        );
        if(response.statusCode == 200)
        {
          final data = jsonDecode(response.body);
          if(data['val'] == 1) {
            message(data['status']);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
          }
          else {
            message(data['status']);
          }
        }

      }
      else{
        message("password not matching");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[850],
                    backgroundImage: AssetImage('assets/avatar.png'),
                    radius: 60,
                  ),
                  SizedBox(height: 50,),
                  Card(
                    child: TextFormField(
                      controller: username,
                      validator: (e)=>e.isEmpty?'Please enter your ID':null,
                      inputFormatters: [BlacklistingTextInputFormatter(new RegExp(r"\s"))],
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 20,right: 15),
                          child: Icon(Icons.person,size: 30,),
                        ),
                        labelText: 'ID',
                        hintText: 'Write your ID',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: users_no,
                      validator: (e)=>e.isEmpty?'Please enter your ID':null,
                      inputFormatters: [BlacklistingTextInputFormatter(new RegExp(r"\s"))],
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 20,right: 15),
                          child: Icon(Icons.person,size: 30,),
                        ),
                        labelText: 'Users number',
                        hintText: 'Write your users number',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: password,
                      validator: (e)=>e.isEmpty?'please enter you\'r password':null,
                      inputFormatters: [BlacklistingTextInputFormatter(new RegExp(r"\s"))],
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 20,right: 15),
                          child: Icon(Icons.phonelink_lock,size: 30,),
                        ),
                        labelText: 'Password',
                        hintText: 'Write your password',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: password_confirm,
                      validator: (e)=>e.isEmpty?'please enter you\'r password':null,
                      inputFormatters: [BlacklistingTextInputFormatter(new RegExp(r"\s"))],
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 20,right: 15),
                          child: Icon(Icons.phonelink_lock,size: 30,),
                        ),
                        labelText: 'Confirm Password',
                        hintText: 'Write your password',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  RaisedButton(
                    onPressed: register,
                    color: Colors.cyan[900],
                    elevation: 0,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
