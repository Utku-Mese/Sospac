import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/video_model.dart';
import '../utils/constants.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  final Rx<List<Video>> _searchedVideos = Rx<List<Video>>([]);

  List<Video> get videoList =>
      _videoList.value.where((video) => video.isVisible).toList();
  List<Video> get searchedVideos => _searchedVideos.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(firestore
        .collection("videos")
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }

  void searchVideosByTag(String tag) {
    _searchedVideos.bindStream(firestore
        .collection("videos")
        .where("tag", isEqualTo: tag)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }

  void clearSearchedVideos() {
    _searchedVideos.value = [];
  }

  Future<void> likeVideo(String videoId) async {
    DocumentSnapshot doc =
        await firestore.collection("videos").doc(videoId).get();

    var uid = authController.user!.uid;

    if ((doc.data()! as dynamic)["likes"].contains(uid)) {
      await firestore.collection("videos").doc(videoId).update({
        "likes": FieldValue.arrayRemove([uid])
      });
    } else {
      await firestore.collection("videos").doc(videoId).update({
        "likes": FieldValue.arrayUnion([uid])
      });
    }
  }
}
