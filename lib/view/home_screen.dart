import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:group/controller/home_screen_controller.dart';
import 'package:group/controller/user_controller.dart';
import 'package:group/model/classes/group.dart';
import 'package:group/model/constants.dart';
import 'package:group/view/create_group_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'group_details_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController(), tag: 'home');
  final UserController _userController = Get.find(tag: 'user');

  void _onRefresh() async {
    await _homeScreenController.getData();
    _homeScreenController.refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Express Yourself',
          style: TextStyle(color: K.mainColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Image.asset(
          'assets/images/logo.png',
        ),
        toolbarHeight: 80,
        actions: [
          IconButton(
            onPressed: () {
              showAnimatedDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return ClassicGeneralDialogWidget(
                    titleText: 'Keep it Clean',
                    contentText:
                        "Don't post adult content, keep the app safe for everyone. Thanks : )",
                    onPositiveClick: () {
                      Navigator.of(context).pop();
                    },
                    onNegativeClick: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
                animationType: DialogTransitionType.size,
                curve: Curves.fastOutSlowIn,
                duration: Duration(seconds: 1),
              );
            },
            icon: Icon(
              Icons.info_rounded,
              color: K.mainColor,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const CreateGroupPage());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: K.mainColor,
      ),
      body: Obx(
        () => AnimationLimiter(
          child: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(
              waterDropColor: Colors.blueGrey.shade900,
            ),
            controller: _homeScreenController.refreshController,
            onRefresh: _onRefresh,
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              children: List.generate(
                _homeScreenController.groups.value.length,
                (int index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(seconds: 1),
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: index % 2 == 0
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(2, 0, 2, 10),
                                child: GroupWidget(
                                  group: _homeScreenController.groups
                                      .elementAt(index),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
                                child: GroupWidget(
                                  group: _homeScreenController.groups
                                      .elementAt(index),
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GroupWidget extends StatelessWidget {
  const GroupWidget({Key? key, required this.group}) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: GestureDetector(
        onTap: () {
          Get.to(() => GroupDetailsPage(group: group));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 8,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Hero(
                        tag: group.name + '/logo',
                        child: group.logoPath == ''
                            ? Image.asset(
                                'assets/images/group-logo.jpg',
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: group.logoPath,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                        child: Text('Error Loading Image')),
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(group.name),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Hero(
                      tag: group.name + '/icon',
                      child: group.iconPath == ''
                          ? Image.asset(
                              'assets/images/group-icon.jpg',
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            )
                          : CachedNetworkImage(
                              imageUrl: group.iconPath,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                      child: Text('Error Loading Image')),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
