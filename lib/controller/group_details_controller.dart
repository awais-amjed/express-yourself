import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:group/model/classes/group.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GroupDetailsController extends GetxController {
  Rx<Group> group = Group(description: '', name: '').obs;

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  Future<void> getData(Group group) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Groups')
        .doc(group.name)
        .get();
    if (snapshot.data() == null) {
      return;
    } else {
      this.group.value = Group.fromJson(snapshot.data()!);
    }
  }
}
