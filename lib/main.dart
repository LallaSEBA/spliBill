
import 'package:flutter/material.dart';
import 'package:split_bill_app/controller/category_provider.dart';
import 'controller/contact_provider.dart';
import 'controller/dbmanager.dart';
import 'ui/category_screen.dart';
import 'ui/contact_screen.dart';
import 'ui/ressources/ressources.dart';
import 'package:provider/provider.dart';

import 'ui/spil_bill_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DBManager.intDB();
  runApp(
    
      MultiProvider(
        providers:[
          ChangeNotifierProvider<ListContact>( create: (_)=>ListContact()),
          ChangeNotifierProvider<ListCategory>( create: (_)=>ListCategory()), ],
          child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.amber[500]) ,
        elevatedButtonTheme: ElevatedButtonThemeData(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.amber[500],
              ))
      ),
      home: const SpitBillScreen(),

            routes: {
              routeCntScreen :(BuildContext context)=>const ContactScreen(),
              routeCategScreen :(BuildContext context)=>const CategoryScreen(),
            },
    );
  }
}

