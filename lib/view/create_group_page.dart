import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:group/controller/create_group_controller.dart';
import 'package:group/controller/home_screen_controller.dart';
import 'package:group/model/constants.dart';
import 'package:group/view/group_details_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage>
    with TickerProviderStateMixin {
  late final AnimationController _logoController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final AnimationController _iconController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final Animation<double> _logoAnimation = CurvedAnimation(
    parent: _logoController,
    curve: Curves.fastOutSlowIn,
  );
  late final Animation<double> _iconAnimation = CurvedAnimation(
    parent: _iconController,
    curve: Curves.fastOutSlowIn,
  );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final CreateGroupController _createGroupController =
      Get.put(CreateGroupController());

  String _groupName = '';
  String _groupDescription = '';
  File? _groupLogo;
  File? _groupIcon;
  bool canCreate = false;

  @override
  void initState() {
    super.initState();
    _logoController.forward();
    _iconController.forward();

    _nameController.addListener(() {
      _groupName = _nameController.value.text;
      setState(() {
        canCreate = _groupName == '' || _groupDescription == '' ? false : true;
      });
    });

    _descriptionController.addListener(() {
      _groupDescription = _descriptionController.value.text;
      setState(() {
        canCreate = _groupName == '' || _groupDescription == '' ? false : true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _logoController.dispose();
    _iconController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        title: Text(
          'Create Group',
          style: TextStyle(color: K.mainColor),
        ),
        elevation: 0.5,
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
                  canCreate ? K.mainColor : Colors.grey.shade300,
                ),
              ),
              child: Text(
                'Create',
                style: TextStyle(color: canCreate ? Colors.white : Colors.grey),
              ),
              onPressed: canCreate
                  ? () async {
                      EasyLoading.show();
                      bool? result = await _createGroupController.createGroup(
                        name: _groupName,
                        description: _groupDescription,
                        groupIcon: _groupIcon,
                        groupLogo: _groupLogo,
                      );
                      EasyLoading.dismiss();
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          K.customSnackBar(
                              'Failed to create a group. Try Again.'),
                        );
                      } else if (result == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          K.customSnackBar(
                              'Group name taken. Choose another name.'),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          K.customSnackBar('Group Created Successfully'),
                        );
                        final HomeScreenController _temp =
                            Get.find(tag: 'home');
                        _temp.refreshController.requestRefresh();
                        Get.off(GroupDetailsPage(
                          group: _createGroupController.newGroup!,
                        ));
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ScaleTransition(
              scale: _logoAnimation,
              child: GestureDetector(
                onTap: () async {
                  final _picker = ImagePicker();
                  XFile? temp =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (temp == null) {
                    return;
                  }
                  setState(() {
                    _groupLogo = File(temp.path);
                    _logoController.reset();
                    _logoController.forward();
                  });
                },
                child: Stack(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 50.h,
                      ),
                      child: _groupLogo != null
                          ? Image.file(
                              _groupLogo!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Image.asset(
                              'assets/images/group-logo.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ScaleTransition(
                        scale: _iconAnimation,
                        child: GestureDetector(
                          onTap: () async {
                            final _picker = ImagePicker();
                            XFile? temp = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (temp == null) {
                              return;
                            }
                            setState(() {
                              _groupIcon = File(temp.path);
                              _iconController.reset();
                              _iconController.forward();
                            });
                          },
                          child: SizedBox(
                            width: 110,
                            height: 110,
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: _groupIcon != null
                                      ? Image.file(
                                          _groupIcon!,
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        )
                                      : Image.asset(
                                          'assets/images/group-icon.jpg',
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(Icons.camera_alt),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _nameController,
                            maxLength: 20,
                            decoration: const InputDecoration(
                              labelText: 'Group Name',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('Describe your group in a few words'),
                  const SizedBox(height: 20),
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _descriptionController,
                    maxLength: 300,
                    maxLines: 8,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignLabelWithHint: true,
                      labelText: 'Short Description',
                    ),
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
