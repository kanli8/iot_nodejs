import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:smart_cook/screens/category_screen.dart';
import 'package:smart_cook/screens/signup_screen.dart';

import 'package:smart_cook/constant/constant.dart';
import 'package:smart_cook/constant/show_snack_bar.dart';
import 'package:smart_cook/sql/appwirte/user.dart';





class LoginScreen extends StatefulWidget {

  static const routeName = '/login-screen';

  
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  void _signIn() {
    signIn2(
      _emailController.text,
      _passwordController.text,
      (){
        setState(() {
          _isLoading = true ;
        });
      },
      (){
        Navigator.pushNamedAndRemoveUntil(context, CategoryScreen.routeName, (route) => false) ;
      },
      ((errMsg){
        setState(() {
          _isLoading = false ;
        });
        context.showErrorSnackBar(message: errMsg) ;
        
        })

    );



  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose() ;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Sign in via the magic link with your email below'),
          const SizedBox(height: 18),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'password'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            child: Text(_isLoading ? 'Loading' : 'sign in'),
          ),
           ElevatedButton(
            onPressed: (){
              Navigator.pushNamed(
                context,
                SignupScreen.routeName
              );
            },
            child: Text(_isLoading ? 'Loading' : 'sign up'),
          ),
        ],
      ),
    );
  }
}




