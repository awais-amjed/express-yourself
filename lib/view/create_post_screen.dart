import 'dart:io';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:group/controller/create_post_controller.dart';
import 'package:group/controller/group_details_controller.dart';
import 'package:group/controller/user_controller.dart';
import 'package:group/model/classes/group.dart';
import 'package:group/model/constants.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key, required this.group}) : super(key: key);

  final Group group;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with TickerProviderStateMixin {
  final CreatePostController _createPostController =
      Get.put(CreatePostController());

  final TextEditingController _textController = TextEditingController();

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.fastOutSlowIn,
  );

  File? _image;
  String _text = '';
  bool _canPost = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      _text = _textController.value.text;
      setState(() {
        _canPost = _text == '' ? false : true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Post',
          style: TextStyle(color: K.mainColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: K.mainColor,
          iconSize: 20,
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  _canPost ? K.mainColor : Colors.grey.shade300,
                ),
              ),
              child: Text(
                'Post',
                style: TextStyle(color: _canPost ? Colors.white : Colors.grey),
              ),
              onPressed: _canPost
                  ? () async {
                      EasyLoading.show();
                      UserController _userController = Get.find(tag: 'user');
                      bool? result = await _createPostController.createPost(
                        name: _userController.userName,
                        text: _text,
                        image: _image,
                        group: widget.group,
                      );
                      EasyLoading.dismiss();
                      if (result == null || result == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          K.customSnackBar(
                              'Failed to upload. Check your internet and Try Again.'),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          K.customSnackBar('Post created successfully'),
                        );
                        GroupDetailsController _temp = Get.find(tag: 'group');
                        _temp.refreshController.requestRefresh();
                        Get.back();
                      }
                    }
                  : null,
            ),
          ),
        ],
        backgroundColor: Colors.grey.shade50,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              maxLines: null,
              controller: _textController,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.grey),
                hintText: "What's on your mind ...",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _image == null
                ? const SizedBox()
                : ScaleTransition(
                    scale: _animation,
                    child: Stack(
                      children: [
                        Image.file(
                          _image!,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _animationController
                                    .reverse()
                                    .then((value) => _image = null);
                              });
                            },
                            icon: DecoratedIcon(
                              Icons.close,
                              color: Colors.grey.shade300,
                              shadows: const [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            TextButton(
              onPressed: () async {
                final _picker = ImagePicker();
                XFile? temp =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (temp == null) {
                  return;
                }
                setState(() {
                  _image = File(temp.path);
                  _animationController.forward();
                });
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.photo,
                    color: Colors.green,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Add an Image',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
