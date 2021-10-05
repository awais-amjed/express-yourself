import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:group/model/classes/group.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreenController extends GetxController {
  RxList<Group> groups = <Group>[].obs;

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Groups').get();
    groups.value =
        snapshot.docs.map<Group>((doc) => Group.fromJson(doc.data())).toList();
  }
}
