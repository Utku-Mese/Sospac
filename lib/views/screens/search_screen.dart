import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/search_controller.dart';
import '../../models/user_model.dart';
import 'profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final MySearchController searchController = Get.put(MySearchController());
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.deepPurpleAccent.shade100);
    final size = MediaQuery.of(context).size;
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            title: TextFormField(
              controller: _textEditingController,
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                ),
                border: InputBorder.none,
              ),
              onFieldSubmitted: (value) => searchController.searchUser(value),
            ),
            backgroundColor: Colors.deepPurpleAccent.shade100,
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () =>
                      searchController.searchUser(_textEditingController.text),
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
            ],
          ),
          body: searchController.searchedUsers.isEmpty
              ? Center(
                  child: Text("Search User!",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        color: Colors.black,
                      )),
                )
              : ListView.builder(
                  itemCount: searchController.searchedUsers.length,
                  itemBuilder: (context, index) {
                    User user = searchController.searchedUsers[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: user.uid,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading:  CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            user.profilePhoto,
                          ),
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
