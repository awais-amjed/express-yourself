import 'dart:io';

import 'package:get/get.dart';
import 'package:group/model/classes/group.dart';
import 'package:group/model/classes/post.dart';
import 'package:group/model/firebase_methods.dart';

class CreatePostController extends GetxController {
  Post? newPost;

  Future<bool?> createPost({
    required String name,
    required String text,
    required File? image,
    required Group group,
  }) async {
    newPost = Post(posterName: name, text: text);
    group.posts.add(newPost!);

    if (image != null) {
      String? result = await FirebaseMethods.uploadImage(
          image: image, groupName: name, isPost: true);
      if (result != null) {
        newPost!.imagePath = result;
      } else {
        return null;
      }
    }

    bool? result = await FirebaseMethods.updateGroup(group: group);
    return result;
  }
}
