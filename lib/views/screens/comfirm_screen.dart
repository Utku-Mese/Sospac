import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/upload_video_controller.dart';
import 'package:video_player/video_player.dart';

import '../widgets/text_input_field.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;

  final String videoPath;

  const ConfirmScreen({
    super.key,
    required this.videoFile,
    required this.videoPath,
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController _controller;
  final TextEditingController _TagController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  final UploadVideoController _uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    setState(() {
      _controller = VideoPlayerController.file(widget.videoFile);
    });
    _controller.initialize();
    _controller.play();
    _controller.setVolume(1);
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: size.width,
              height: size.height / 1.5,
              child: VideoPlayer(_controller),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: "Caption",
                      icon: Icons.short_text_rounded,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: size.width - 20,
                    child: TextInputField(
                      controller: _TagController,
                      labelText: "Tag",
                      icon: Icons.tag,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    // Show CircularProgressIndicator only when isUploading is true
                    if (_uploadVideoController.isUploading.value) {
                      return Column(
                        children: const [
                          Text("Please wait while upload your video"),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(),
                        ],
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () => _uploadVideoController.uploadVideo(
                          caption: _captionController.text,
                          tag: _TagController.text,
                          videoPath: widget.videoPath,
                        ),
                        child: Text(
                          "Post",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
