import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/search_controller.dart';
import '../../controllers/video_controller.dart';
import '../../models/user_model.dart';
import '../../models/video_model.dart';
import 'profile_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MySearchController searchController = Get.put(MySearchController());

  final VideoController videoController = Get.put(VideoController());

  final TextEditingController _searchController = TextEditingController();

  final RxBool isVideoSearch = false.obs;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.deepPurpleAccent.shade100);

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: isVideoSearch.value ? "Search Videos" : "Search Users",
            hintStyle: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                searchController.clearSearch();
                videoController.clearSearchedVideos();
              },
            ),
          ),
          onFieldSubmitted: (value) {
            if (isVideoSearch.value) {
              videoController.searchVideosByTag(value);
            } else {
              searchController.searchUser(value);
            }
          },
        ),
        backgroundColor: Colors.deepPurpleAccent.shade100,
        elevation: 0,
        actions: [
          Obx(() {
            return Row(
              children: [
                Switch(
                  value: isVideoSearch.value,
                  onChanged: (value) {
                    setState(() {
                      isVideoSearch.value = value;
                    });
                    _searchController.clear();
                    searchController.clearSearch();
                    videoController.clearSearchedVideos();
                  },
                  activeColor: Colors.white,
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    if (isVideoSearch.value) {
                      videoController.searchVideosByTag(_searchController.text);
                    } else {
                      searchController.searchUser(_searchController.text);
                    }
                  },
                ),
              ],
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(() {
                if (!isVideoSearch.value &&
                    searchController.searchedUsers.isEmpty &&
                    _searchController.text.isEmpty) {
                  return _buildSearchHistory();
                }

                if (isVideoSearch.value &&
                    videoController.searchedVideos.isEmpty &&
                    _searchController.text.isEmpty) {
                  return _buildSearchHistory();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isVideoSearch.value &&
                        searchController.searchedUsers.isNotEmpty)
                      _buildUserResults(searchController.searchedUsers),
                    if (isVideoSearch.value &&
                        videoController.searchedVideos.isNotEmpty)
                      _buildVideoResults(videoController.searchedVideos),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  _searchController.text = search;
                  if (isVideoSearch.value) {
                    videoController.searchVideosByTag(search);
                  } else {
                    searchController.searchUser(search);
                  }
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

  Widget _buildUserResults(List<User> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "User Results",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            User user = users[index];
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
        ),
      ],
    );
  }

  Widget _buildVideoResults(List<Video> videos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Video Results",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            Video video = videos[index];
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: video.thumbnail,
              ),
              title: Text(
                video.caption,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "by ${video.username}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      uid: video.username,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
