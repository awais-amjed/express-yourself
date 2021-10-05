import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:group/controller/group_details_controller.dart';
import 'package:group/model/classes/group.dart';
import 'package:group/model/classes/post.dart';
import 'package:group/model/constants.dart';
import 'package:group/model/firebase_methods.dart';
import 'package:group/view/create_post_screen.dart';
import 'package:like_button/like_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

class GroupDetailsPage extends StatelessWidget {
  GroupDetailsPage({Key? key, required this.group}) : super(key: key);

  final Group group;

  final GroupDetailsController _groupDetailsController =
      Get.put(GroupDetailsController(), tag: 'group');

  void _onRefresh() async {
    await _groupDetailsController.getData(group);
    _groupDetailsController.refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    _groupDetailsController.group.value = group;
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        header: const MaterialClassicHeader(),
        controller: _groupDetailsController.refreshController,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 40.h,
                    ),
                    child: Hero(
                      tag: group.name + '/logo',
                      child: group.logoPath == ''
                          ? Image.asset(
                              'assets/images/group-logo.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : CachedNetworkImage(
                              imageUrl: group.logoPath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                      child: Text('Error Loading Image')),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      group.name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      group.description,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        ClipOval(
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
                        const SizedBox(width: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: TextButton(
                              onPressed: () {
                                Get.to(() => CreatePostScreen(group: group));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(K.mainColor),
                              ),
                              child: const Text(
                                'Create Post',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            _groupDetailsController.group.value.posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 1000),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: PostWidget(
                                  post: _groupDetailsController
                                      .group.value.posts
                                      .elementAt(index),
                                  onLike: (value) {
                                    _groupDetailsController.group.value.posts
                                        .elementAt(index)
                                        .likeCount = value;
                                    FirebaseMethods.updateGroup(
                                        group: _groupDetailsController
                                            .group.value);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SafeArea(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(left: 5),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    iconSize: 20,
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

class PostWidget extends StatelessWidget {
  const PostWidget({Key? key, required this.post, required this.onLike})
      : super(key: key);

  final Post post;
  final Function onLike;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    post.posterName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(post.text),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                post.imagePath == ''
                    ? const SizedBox()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: post.imagePath,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Center(child: Text('Error Loading Image')),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          LikeButton(
                            onTap: (value) async {
                              if (!value) {
                                post.likeCount++;
                              } else {
                                post.likeCount--;
                              }
                              onLike(post.likeCount);
                              return !value;
                            },
                            likeBuilder: (value) {
                              return value
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      color: Colors.grey,
                                    );
                            },
                            likeCount: post.likeCount,
                          ),
                        ],
                      ),
                      const Text(
                        '27 Aug, 2017',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
