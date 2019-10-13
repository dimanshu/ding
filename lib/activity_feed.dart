import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'image_post.dart'; //needed to open image when clicked
import 'profile_page.dart'; // to open the profile page when username clicked
import 'main.dart'; //needed for currentuser id
import 'package:intl/intl.dart';

class ActivityFeedPage extends StatefulWidget {
  @override
  _ActivityFeedPageState createState() => _ActivityFeedPageState();
}

class _ActivityFeedPageState extends State<ActivityFeedPage> with AutomaticKeepAliveClientMixin<ActivityFeedPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: buildActivityFeed(),
    );
  }

  buildActivityFeed() {
    return Container(
      child: FutureBuilder(
          future: getFeed(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator());
            else {
              return ListView(children: snapshot.data);
            }
          }),
    );
  }

  getFeed() async {
    List<ActivityFeedItem> items = [];
    var snap = await Firestore.instance
        .collection('ding_gaurav')
        .document(currentUserModel.id)
        .collection("items")
        .where('like', isEqualTo: 1)
        .getDocuments();
      print(snap.documents);
    for (var doc in snap.documents) {
      items.add(ActivityFeedItem.fromDocument(doc));
    }print(items);
    return items;
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;

}

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  // types include liked photo, follow user, comment on photo
  final String mediaUrl;
  final String mediaId;
  final String userProfileImg;
  var liker_image;
  final String liker_id;
  final String liker_name;


  ActivityFeedItem(
      {this.username,
      this.userId,

      this.mediaUrl,
      this.mediaId,
      this.userProfileImg,
        this.liker_image,
        this.liker_id,
        this.liker_name,
      });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot document) {
    return ActivityFeedItem(
      username: document['username'],
      userId: document['userId'],

      mediaUrl: document['mediaUrl'],
      mediaId: document['postId'],
      userProfileImg: document['userProfileImg'],
      liker_image: document['liker_image'],
      liker_id: document['liker_id'],
      liker_name: document['liker_name'],

    );
  }

  Widget mediaPreview = Container();
  String actionText = " Liked Your Profile";

  void configureItem(BuildContext context) {
    if (1== 1 ) {
      mediaPreview = GestureDetector(
        onTap: () {

        },
        child: Container(
          height: 45.0,
          width: 45.0,
          child: AspectRatio(
            aspectRatio: 487 / 451,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                alignment: FractionalOffset.topCenter,
                image: NetworkImage(currentUserModel.photoUrl),
              )),
            ),
          ),
        ),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    configureItem(context);
    return
      GestureDetector(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 15.0, top: 14.0),
          child: CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(liker_image),
          ),
        ),

        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                Text(
                  toBeginningOfSentenceCase(liker_name),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              Flexible(
                child: Container(
                  child: Text(
                    actionText,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ),
          onTap: () {

            print(liker_id);
            openProfile(context, liker_id);
          });
  }
}

