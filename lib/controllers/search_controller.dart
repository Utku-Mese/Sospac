import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class MySearchController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

  List<User> get searchedUsers => _searchedUsers.value;

  var recentSearches = <String>[].obs;
  var frequentSearches = <String>[].obs;

  final String recentSearchesKey = 'recent_searches';
  final String frequentSearchesKey = 'frequent_searches';

  @override
  void onInit() {
    super.onInit();
    _loadSearchHistory();
  }

  void _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    recentSearches.value = prefs.getStringList(recentSearchesKey) ?? [];
    frequentSearches.value = prefs.getStringList(frequentSearchesKey) ?? [];
  }

  void _saveSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(recentSearchesKey, recentSearches);
    await prefs.setStringList(frequentSearchesKey, frequentSearches);
  }

  void clearSearch() {
    _searchedUsers.value = [];
  }

  void searchUser(String typedUser) {
    if (typedUser.isEmpty) return;

    _searchedUsers.bindStream(
      firestore
          .collection("users")
          .where("name", isGreaterThanOrEqualTo: typedUser)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<User> retVal = [];
          for (var element in query.docs) {
            retVal.add(User.fromSnap(element));
          }
          return retVal;
        },
      ),
    );

    _updateSearchHistory(typedUser);
  }

  void _updateSearchHistory(String query) {
    if (recentSearches.contains(query)) {
      recentSearches.remove(query);
    }
    recentSearches.insert(0, query);
    if (recentSearches.length > 10) {
      recentSearches.removeLast();
    }

    if (!frequentSearches.contains(query)) {
      frequentSearches.add(query);
    }
    if (frequentSearches.length > 10) {
      frequentSearches.removeLast();
    }

    _saveSearchHistory();
  }

  void clearRecentSearches() {
    recentSearches.clear();
    _saveSearchHistory();
  }

  void clearFrequentSearches() {
    frequentSearches.clear();
    _saveSearchHistory();
  }
}
