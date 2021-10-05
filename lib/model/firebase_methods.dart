import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'classes/group.dart';

class FirebaseMethods {
  static Future<String?> uploadImage({
    required File image,
    required String groupName,
    isPost = false,
  }) async {
    Reference ref = FirebaseStorage.instance.ref();
    TaskSnapshot addImg = await ref
        .child(
            "images/$groupName${isPost ? '/Posts' : ''}/${basename(image.path)}")
        .putFile(image);
    if (addImg.state == TaskState.success) {
      final String downloadUrl = await addImg.ref.getDownloadURL();
      return downloadUrl;
    }
  }

  static Future<bool?> addGroup({required Group group}) async {
    bool? result;

    await FirebaseFirestore.instance
        .collection('Groups')
        .doc(group.name)
        .set(jsonDecode(jsonEncode(group)))
        .then((value) => result = true);

    return result;
  }

  static Future<bool?> updateGroup({required Group group}) async {
    bool? result;
    try {
      await FirebaseFirestore.instance
          .collection('Groups')
          .doc(group.name)
          .update(jsonDecode(jsonEncode(group)))
          .then((value) => result = true);
    } catch (e) {
      print('ERROR: $e');
      return result;
    }
    return result;
  }
}
