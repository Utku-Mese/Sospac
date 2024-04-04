import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String id;
  String profilePhoto;
  String uid;
  String caption;
  String tag;
  String videoUrl;
  String thumbnail;
  List likes;
  int commentCount;
  int shareCount;
  DateTime createdAt;

  Video({
    required this.username,
    required this.id,
    required this.profilePhoto,
    required this.uid,
    required this.caption,
    required this.tag,
    required this.videoUrl,
    required this.thumbnail,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'id': id,
        'profilePhoto': profilePhoto,
        'uid': uid,
        'caption': caption,
        'tag': tag,
        'videoUrl': videoUrl,
        'thumbnail': thumbnail,
        'likes': likes,
        'commentCount': commentCount,
        'shareCount': shareCount,
        'createdAt': createdAt,
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
        username: snapshot['username'],
        id: snapshot['id'],
        profilePhoto: snapshot['profilePhoto'],
        uid: snapshot['uid'],
        caption: snapshot['caption'],
        tag: snapshot['tag'],
        videoUrl: snapshot['videoUrl'],
        thumbnail: snapshot['thumbnail'],
        likes: snapshot['likes'],
        commentCount: snapshot['commentCount'],
        shareCount: snapshot['shareCount'],
        createdAt: snapshot['createdAt'].toDate());
  }
}
