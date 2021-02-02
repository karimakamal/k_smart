import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_smart/admin.dart';
import 'package:k_smart/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final _key = GlobalKey<FormState>();

  void saveSession(Map user, int s)async{
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setString("user", json.encode(user));
    p.setInt("status", s);
    p.commit();
  }

  int status = 0;
  Map user;

  void getSession()async{
    SharedPreferences p = await SharedPreferences.getInstance();
    if (p.getInt("status") == 1) {
      setState(() {
        status = 1;
        user = json.decode(p.getString("user"));
      });
    }else{
      setState(() {
        status = 0;
      });
    }
    print(p.getString("status"));
  }

  void login() async{
    if(_key.currentState.validate()) {
        final response = await http.post(
          "https://easesp8266.000webhostapp.com/file.php",
          body: {
            "userid": username.text,
            "type": '2',
            "pass": password.text,
          },
        );
        if(response.statusCode == 200)
        {
          final data = jsonDecode(response.body);
          if(data['val'] == 1) {
            message(data['status']);
            print(data['info']);
            saveSession(data['info'], 1);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin(user: data['info'])));
          }
          else {
            message(data['status']);
            print(data['username']);
          }        }

      }
  }

  logOut() async{
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      p.setString("user", null);
      p.setInt("status", null);
      status = 0;
      p.commit();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    switch (status){
      case 1:
        return Admin(user: user, signOut: logOut,);
        break;
      case 0:
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
                      FlatButton(
                        onPressed: getSession,
                        child: Text(
                          'Forget password',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: login,
                        color: Colors.cyan[900],
                        elevation: 0,
                        child: Text(
                          'Login',
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
                            'don\'t have an account!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                            },
                            child: Text(
                              'Sign Up',
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
        break;
      default:
    }
  }
}


