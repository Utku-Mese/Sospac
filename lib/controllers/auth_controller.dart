import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart' as Umodel;
import '../utils/constants.dart';
import '../views/screens/auth/login_screen.dart';
import '../views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  String downloadUrl =
      "https://cdn-icons-png.flaticon.com/512/847/847969.png?w=740&t=st=1690124807~exp=1690125407~hmac=62e162d8114cb9b66801673f94a7abfbf3a0f38a28d78caea82d5e1c9d89d529";

  late Rx<User?> _user;

  late Rx<File?> _pickedImage =
      Rx<File?>(File("asset/image/defauldProfilePicture/profilePicture.png"));

  File? get profilePhoto => _pickedImage.value;

  User? get user => _user.value;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Password Reset",
        "Password reset email has been sent!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to send password reset email",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void pickImage() async {
    final picedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picedImage != null) {
      Get.snackbar(
        "Profile picture",
        "successfully picked!",
      );
      _pickedImage = Rx<File?>(File(picedImage.path));
    } else {
      Get.snackbar(
        "Error picking image",
        "Please try again",
      );
      _pickedImage = Rx<File?>(
        File("asset/image/defauldProfilePicture/profilePicture.png"),
      );
    }
  }

  //Upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    try {
      var snapshot = await firebaseStorage
          .ref()
          .child('userProfile/${firebaseAuth.currentUser!.uid}')
          .putFile(image);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Get.snackbar(
        "Error uploading image",
        e.toString(),
      );
      rethrow;
    }
  }

  //register user
  void registerUser(
      String Username, String email, String password, File? image) async {
    try {
      if (Username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        downloadUrl = await _uploadToStorage(image);
        Umodel.User user = Umodel.User(
          name: Username,
          email: email,
          profilePhoto: downloadUrl,
          uid: cred.user!.uid,
        );
        firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        //Get.back(); //? LOOK HERE
      } else {
        Get.snackbar(
          "Error creating account",
          "Please fill all fields",
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error creating account",
        e.toString(),
      );
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        Get.snackbar(
          "Error logging in",
          "Please fill all fields",
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error logging in",
        e.toString(),
      );
    }
  }

  void loginUserWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);

        if (userCredential.user != null) {
           Get.offAll(() => const HomeScreen()); //Todo: Look here (gerekmeyebilir)
        }
      }
    } catch (e) {
      Get.snackbar(
        "Google Sign In Error",
        e.toString(),
      );
    }
  }

  signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      Get.snackbar(
        "Error signing out",
        e.toString(),
      );
    }
  }
}
