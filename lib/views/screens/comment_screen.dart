import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../controllers/comment_controller.dart';
import '../../utils/constants.dart';
import 'profile_screen.dart';

class CommentScreen extends StatelessWidget {
  final String id;
  CommentScreen({super.key, required this.id});

  final TextEditingController _commentController = TextEditingController();

  CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height - 85,
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () {
                    return ListView.builder(
                      itemCount: commentController.comments.length,
                      itemBuilder: (context, index) {
                        final comment = commentController.comments[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    uid: comment.uid,
                                  ),
                                ),
                              );
                            },
                            child:  CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(comment.profilePhoto),
                            ),
                          ),
                          title: Text(
                            comment.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.comment,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(175, 0, 0, 0),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    timeago.format(
                                      comment.datePublished.toDate(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text("${comment.likes.length} likes"),
                                ],
                              )
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              comment.likes.contains(authController.user!.uid)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: comment.likes
                                      .contains(authController.user!.uid)
                                  ? Colors.red
                                  : null,
                            ),
                            onPressed: () {
                              commentController.likeComment(comment.id);
                            },
                            splashRadius: 10,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                title: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: InputBorder.none,
                  ),
                  controller: _commentController,
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.deepPurpleAccent.shade100,
                  ),
                  onPressed: () {
                    commentController.postComment(_commentController.text);
                    _commentController.clear();
                  },
                  splashRadius: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
