import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/storage/local_store.dart';

//  <--------- App Entry Point --------->
//* TO boot the app once Firebase and persisted state are ready
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  <--------- Firebase --------->
  await FirebaseBootstrap.initialize();

  //  <--------- Persisted State --------->
  //* TO load favorites, bag, history and theme before the first frame so the UI never starts in an unknown state
  final store = await LocalStore.create();

  runApp(ProductExplorerApp(store: store));
}
