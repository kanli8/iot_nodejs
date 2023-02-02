
import 'package:flutter/material.dart';






class ActivatScreen extends StatefulWidget {

  static const routeName = '/activat-screen';

  
  const ActivatScreen({Key? key}) : super(key: key);

  @override
  _ActivatScreenState createState() => _ActivatScreenState();
}

class _ActivatScreenState extends State<ActivatScreen> {
  // final bool _isLoading = false;




  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activat')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        // children: [
          
        // ],
      ),
    );
  }
}




