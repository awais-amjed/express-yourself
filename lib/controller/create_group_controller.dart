import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:group/model/classes/group.dart';
import 'package:group/model/firebase_methods.dart';

class CreateGroupController extends GetxController {
  Group? newGroup;

  Future<bool?> createGroup({
    required String name,
    required String description,
    required File? groupIcon,
    required File? groupLogo,
  }) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance
          .collection('Groups')
          .doc(name)
          .get()
          .then((doc) async => {if (doc.exists) exists = true});
    } catch (e) {
      print('ERROR: $e');
      return null;
    }

    if (exists) {
      return false;
    }

    newGroup = Group(name: name, description: description);
    if (groupLogo != null) {
      String? result =
          await FirebaseMethods.uploadImage(image: groupLogo, groupName: name);
      if (result != null) {
        newGroup!.logoPath = result;
      } else {
        return null;
      }
    }
    if (groupIcon != null) {
      String? result =
          await FirebaseMethods.uploadImage(image: groupIcon, groupName: name);
      if (result != null) {
        newGroup!.iconPath = result;
      } else {
        return null;
      }
    }

    bool? result = await FirebaseMethods.addGroup(group: newGroup!);
    return result;
  }
}
