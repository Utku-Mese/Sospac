import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/video_controller.dart';
import '../../utils/constants.dart';
import 'comment_screen.dart';
import 'profile_screen.dart';
import '../widgets/video_player_item.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({super.key});

  final VideoController videoController = Get.put(
      VideoController()); //! if not working, try to this line add state class

  buildProfilePhoto(String profilePhoto) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(profilePhoto),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: Colors.black, // Todo: Delete this line
      body: Obx(() {
        if (videoController.videoList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        }
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];
            return Stack(
              children: [
                VideoPlayerItem(
                  videoUrl: data.videoUrl,
                ), // Todo: video player item
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                      bottom: 15,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ProfileScreen(
                                              uid: data.uid,
                                            ),
                                          ),
                                        );
                                      },
                                      child: data.profilePhoto.isEmpty
                                          ? const CircularProgressIndicator(
                                              color: Colors.purple,
                                            )
                                          : buildProfilePhoto(
                                              data.profilePhoto),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.50,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              data.username,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              daysBetween(data.createdAt) == 0
                                                  ? "Today"
                                                  : daysBetween(
                                                              data.createdAt) ==
                                                          1
                                                      ? "Yesterday"
                                                      : "${daysBetween(data.createdAt)} days ago",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          data.caption,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            data.tag != ""
                                                ? const Icon(
                                                    Icons.tag,
                                                    size: 13,
                                                    color: Colors.white,
                                                  )
                                                : Container(),
                                            Text(
                                              data.tag,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: const EdgeInsets.only(right: 20),
                            margin: EdgeInsets.only(
                                top: size.height / 4, bottom: 20),
                            child: Column(
                              //Todo: update row to column
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        videoController.likeVideo(data.id);
                                      },
                                      child: Icon(
                                        data.likes.contains(
                                                authController.user!.uid)
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        size: 40,
                                        color: data.likes.contains(
                                                authController.user!.uid)
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      data.likes.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => CommentScreen(
                                              id: data.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.comment_outlined,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      data.commentCount.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        share(
                                          "SOSPAC",
                                          "Check out this video on SOSPAC",
                                          data.videoUrl,
                                        );
                                      },
                                      child: const Icon(
                                        Icons.reply_outlined,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    /* Text(
                                      data.shareCount.toString(), // Share count
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ), */
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        );
      }),
    );
  }
}
