import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sospac/views/screens/comfirm_screen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  pickVideo(ImageSource source, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: source);
    if (video != null) {
      final file = File(video.path);
      final fileSize = await file.length();
      final fileExtension = file.path.split('.').last;

      if (fileSize > 50000000) {
        // 50MB
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Video size exceeds the limit of 50MB."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!['mp4', 'mov'].contains(fileExtension)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Unsupported video format. Please upload MP4 or MOV."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoPath: video.path,
            videoFile: File(video.path),
          ),
        ),
      );
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        elevation: 10,
        shadowColor: Colors.amber,
        title: Text(
          'Choose an option',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurpleAccent.shade100,
          ),
        ),
        contentPadding: const EdgeInsets.all(20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: SimpleDialogOption(
                onPressed: () => pickVideo(ImageSource.camera, context),
                child: Row(
                  children: [
                    const Icon(
                      Icons.video_call_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Camera',
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: SimpleDialogOption(
                onPressed: () => pickVideo(ImageSource.gallery, context),
                child: Row(
                  children: [
                    const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 35,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Gallery',
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(),
                child: Row(
                  children: [
                    const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 35,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Close',
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.deepPurpleAccent.shade100);
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Lets!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    const Shadow(
                      color: Colors.amber,
                      blurRadius: 10,
                      offset: Offset(3, 4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Share a video and start creating your social space",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Follow the steps to share your video:",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "1. Tap 'Add Video' button",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "2. Choose 'Camera' or 'Gallery'",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "3. Confirm and upload",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 110),
            InkWell(
              onTap: () => showOptionsDialog(context),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 60),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                height: 70,
                width: Size.infinite.width,
                child: Center(
                  child: Text(
                    'Add Video',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
