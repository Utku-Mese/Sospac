import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class MySearchController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

  List<User> get searchedUsers => _searchedUsers.value;

  searchUser(String typedUser) {
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
  }
}
