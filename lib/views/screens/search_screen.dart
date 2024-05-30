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
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _textEditingController.clear();
                searchController.clearSearch();
              },
            ),
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
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (searchController.searchedUsers.isEmpty &&
                  _textEditingController.text.isEmpty) {
                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    _buildSearchHistorySection(
                      title: "Recent Searches",
                      searches: searchController.recentSearches,
                      onClear: searchController.clearRecentSearches,
                    ),
                    SizedBox(height: 20),
                    _buildSearchHistorySection(
                      title: "Frequent Searches",
                      searches: searchController.frequentSearches,
                      onClear: searchController.clearFrequentSearches,
                    ),
                  ],
                );
              }

              if (searchController.searchedUsers.isEmpty) {
                return Center(
                  child: Text(
                    "No users found.",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                );
              }

              return ListView.builder(
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
                      leading: CircleAvatar(
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
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistorySection({
    required String title,
    required List<String> searches,
    required VoidCallback onClear,
  }) {
    return Obx(() {
      if (searches.isEmpty) {
        return Container();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(Icons.clear, color: Colors.black),
                onPressed: onClear,
              ),
            ],
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: searches.map((search) {
              return GestureDetector(
                onTap: () {
                  _textEditingController.text = search;
                  searchController.searchUser(search);
                },
                child: Chip(
                  label: Text(
                    search,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
