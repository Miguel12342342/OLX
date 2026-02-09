import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx/firebase_options.dart';
import 'package:olx/route_generator.dart';
import 'package:olx/views/anuncios.dart';
import 'package:olx/views/widgets/theme_data.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /* FirebaseFirestore.instance
    .collection("usuarios")
    .doc("001")
    .set({"nome": "Miguel"});
 */

  runApp(
    MaterialApp(
      home: Anuncios(),
      theme: TemaCustomizado.temaPadrao,
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    ),
  );
}