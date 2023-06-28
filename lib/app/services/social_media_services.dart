import 'package:google_sign_in/google_sign_in.dart';

class SocialMediaServices {
  GoogleSignIn googleSignInData = GoogleSignIn(scopes: ['email']);
  Future<GoogleSignIn?> googleSignIn() async {
   
    try {
      await googleSignInData.signIn();
      return googleSignInData;
    } catch (error) {
      print('Google Sign-In error: $error');
    }
    return null;
  }
}
