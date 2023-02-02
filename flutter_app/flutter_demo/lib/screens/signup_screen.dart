import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:smart_cook/constant/constant.dart';
import 'package:smart_cook/constant/show_snack_bar.dart';
import 'package:smart_cook/sql/appwirte/user.dart';
import 'package:uuid/uuid.dart';




class SignupScreen extends StatefulWidget {

  static const routeName = '/signup-screen';

  
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;

  Future<void> _signUp() async {

    signup2(
      name: _nameController.text, 
      email: _emailController.text,
      password:_passwordController.text,
      onLoading: (){
        setState(() {
       _isLoading = true;
     });
      },
      onSuccess: (){
          context.showInfoSnackBar(message: 'reg success , return sign in page');
          Future.delayed(const Duration(seconds: 3),(){
            Navigator.pop(context);
          });
      },
      onError: (String msg){
        context.showErrorSnackBar(message: msg);          setState(() {
          _isLoading = false;
        });
      }
    );


   
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose() ;
    _nameController.dispose() ;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Sign in via the magic link with your email below'),
          const SizedBox(height: 18),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'name'),
          ),
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
            onPressed: _isLoading ? null : _signUp,
            child: Text(_isLoading ? 'Loading' : 'sign up'),
          ),
           ElevatedButton(
            onPressed:  _signUp,
            child: const Text('sign up'),
          ),
        ],
      ),
    );
  }
}


