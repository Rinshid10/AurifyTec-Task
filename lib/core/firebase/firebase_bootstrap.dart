import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

//  <--------- Firebase Bootstrap --------->
//* TO start Firebase before the first frame so auth is ready when the first screen builds
class FirebaseBootstrap {
  FirebaseBootstrap._();

  //  <--------- Initialise --------->
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //  <--------- Session Restore --------->
    //* TO wait for Firebase to restore any persisted session so currentUser is correct at startup
    await FirebaseAuth.instance.authStateChanges().first;
  }
}
