import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  final Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];
    var myVideos = await firestore
        .collection("videos")
        .where("uid", isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)["thumbnail"]);
    }

    DocumentSnapshot userDoc =
        await firestore.collection("users").doc(_uid.value).get();

    final userData = userDoc.data()! as dynamic;
    String name = userData["name"];
    String profilePhoto = userData["profilePhoto"];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideos.docs) {
      likes += (item.data()["likes"] as List).length;
    }

    var followersDoc = await firestore
        .collection("users")
        .doc(_uid.value)
        .collection("followers")
        .get();

    var followingDoc = await firestore
        .collection("users")
        .doc(_uid.value)
        .collection("following")
        .get();

    followers = followersDoc.docs.length;
    following = followingDoc.docs.length;

    firestore
        .collection("users")
        .doc(_uid.value)
        .collection("followers")
        .doc(authController.user!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      "name": name,
      "profilePhoto": profilePhoto,
      "likes": likes.toString(),
      "followers": followers.toString(),
      "following": following.toString(),
      "isFollowing": isFollowing,
      "thumbnails": thumbnails,
    };
    update();
  }

  followUser() async {
    var doc = await firestore
        .collection("users")
        .doc(_uid.value)
        .collection("followers")
        .doc(authController.user!.uid)
        .get();

    if (!doc.exists) {
      await firestore
          .collection("users")
          .doc(_uid.value)
          .collection("followers")
          .doc(authController.user!.uid)
          .set({});
      await firestore
          .collection("users")
          .doc(authController.user!.uid)
          .collection("following")
          .doc(_uid.value)
          .set({});

      _user.value.update(
        "followers",
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await firestore
          .collection("users")
          .doc(_uid.value)
          .collection("followers")
          .doc(authController.user!.uid)
          .delete();

      await firestore
          .collection("users")
          .doc(authController.user!.uid)
          .collection("following")
          .doc(_uid.value)
          .delete();
      _user.value.update(
        "followers",
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update(
      "isFollowing",
      (value) => !value,
    );
    update();
  }

  reportUser() async {
    if (authController.user!.uid == _uid.value) {
      Get.snackbar(
        "Error",
        "You can't report yourself",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    } else {
      await firestore.collection("reports").add({
        "uid": _uid.value,
        "reportedBy": authController.user!.uid,
        "time": Timestamp.now(),
      });
      Get.snackbar(
        "Success",
        "User reported successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
