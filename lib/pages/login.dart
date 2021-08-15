import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

  // to save login details
  class _LoginState extends State<Login> {
  _setSharedPreferencesLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isloggedin', true);
  }


  static const color = Color.fromRGBO(46,47,51,1);
  bool is_username_validated = false;
  bool is_password_validated = false;

  final UserNameController = TextEditingController();
  final PasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();

    // Only in this screen portraitUp is allowed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    UserNameController.dispose();
    PasswordController.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: color,

          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                      width: MediaQuery. of(context). size. width,
                      height: 200,

                      child: Image.asset('images/gametv.jpeg'),),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(30) ,topRight: Radius.circular(30),),
                  child: Container(
                    height: MediaQuery. of(context). size. height-200,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30,top: 50,right: 10,bottom: 10),
                          child: Row(
                            children: [
                              Text("WELCOME BACK  ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                              Icon(
                                  Icons.sports_esports,
                                color: Colors.blue,
                                size: 30.0,
                              ),
                              Icon(
                                Icons.cable,
                                color: Colors.blue,
                                size: 30.0,
                              ),
                              Icon(
                                Icons.devices,
                                color: Colors.blue,
                                size: 30.0,
                              ),
                            ],
                          )
                        ),
                    Padding(
                    padding: EdgeInsets.only(left: 15,top: 40,right: 15,bottom: 10),
                    child: TextFormField(
                      controller: UserNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          hintText: 'Enter valid Username'),
                      onChanged: (username){
                        if(username!=""){
                          _formKey.currentState!.validate();
                        }

                      },
                      validator: (username) {
                        if (username=="") {
                          setState(() {
                            is_username_validated=false;
                          });
                          return "* Required";
                        } else if (username!.length < 3) {
                          setState(() {
                            is_username_validated=false;
                          });
                          return "Username should be atleast 3 characters";
                        } else if (username.length > 10) {
                          setState(() {
                            is_password_validated=false;
                          });
                          return "Username should not be greater than 10 characters";
                        } else{
                          setState(() {
                            is_username_validated=true;
                          });
                          return null;
                        }

                      },
                    ),

                  ),
                    Padding(
                    padding: EdgeInsets.only(left: 15,top: 40,right: 15,bottom: 10),

                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                    controller: PasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                    onChanged: (password){
                    if(password!=""){
                    _formKey.currentState!.validate();
                    }

                    },

                    validator: (password) {
                        if (password=="") {
                    setState(() {
                      is_password_validated=false;
                    });
                    return "* Required";
                  } else if (password!.length < 3) {
                    setState(() {
                      is_password_validated=false;
                    });
                    return "Password should be atleast 3 characters";
                  } else if (password.length > 11) {
                    setState(() {
                      is_password_validated=false;
                    });
                    return "Password should not be greater than 11 characters";
                  } else{
                    setState(() {
                      is_password_validated=true;
                    });
                    return null;
                      }

                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                           style: ButtonStyle(
                             backgroundColor: is_username_validated&&is_password_validated ?MaterialStateProperty.all<Color>(Colors.blue):MaterialStateProperty.all<Color>(Colors.grey),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                                  ),

                           onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if((UserNameController.text=="9898989898"|| UserNameController.text=="9876543210" )&& PasswordController.text=="password123")
                            {
                              await _setSharedPreferencesLoggedIn();
                              Navigator.pushReplacementNamed(context, "/home");
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:  Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.error ,color: Colors.red, size: 30,),
                                    ),
                                    Text('Login Failed',  style: TextStyle(color: Colors.white, fontSize: 18,fontWeight:FontWeight.bold),),
                                  ],
                                ),
                                backgroundColor: color,
                                duration:  Duration(seconds: 1),
                              ));
                            }
                          }

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white, fontSize: 25),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Icon(

                        is_username_validated&&is_password_validated ?Icons.thumb_up:Icons.thumb_up_off_alt,

                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
                      ],
                    )

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}




