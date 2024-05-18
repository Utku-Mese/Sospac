import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../models/video_model.dart';
import 'package:video_compress/video_compress.dart';

import '../utils/constants.dart';

class UploadVideoController extends GetxController {
  var isUploading = false.obs;

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.LowQuality, //? VideoQuality
    );
    return compressedVideo!.file;
  }

  _getThumnnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);

    UploadTask uploadTask = ref.putFile(await _getThumnnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  /* _uploadVideoToFirestore(String caption, String tag, String videoUrl) async {
    String uid = firebaseAuth.currentUser!.uid;
    DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();
    // get id
    var allDocs = await firestore.collection('videos').get();
    int len = allDocs.docs.length;
    await firestore.collection('videos').doc('Video $len').set({
      'id': 'Video $len',
      'caption': caption,
      'tag': tag,
      'videoUrl': videoUrl,
      'likes': [],
      'comments': [],
      'shares': [],
      'views': [],
      'user': {
        'id': uid,
        'name': userDoc['name'],
        'profilePic': userDoc['profilePic'],
      },
      'createdAt': DateTime.now(),
    });
  } */

  // upload video
  uploadVideo(
      {required String caption,
      required String tag,
      required String videoPath}) async {
    try {
      isUploading.value = true;
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length + 1;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        id: "Video $len",
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        uid: uid,
        caption: caption,
        tag: tag,
        videoUrl: videoUrl,
        thumbnail: thumbnail,
        likes: [],
        commentCount: 0,
        shareCount: 0,
        isVisible: true,
        createdAt: DateTime.now(),
      );

      await firestore
          .collection("videos")
          .doc("Video $len")
          .set(video.toJson());
      isUploading.value = false;
      Get.back();
    } catch (e) {
      isUploading.value = false;
      Get.snackbar(
        "Error Uploading Video",
        e.toString(),
      );
    }
  }
}
