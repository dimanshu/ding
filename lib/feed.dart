import 'package:flutter/material.dart';
import 'image_post.dart';
import 'dart:async';
import 'main.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import "profile_page.dart"; // needed to import for openProfile function
import 'models/user.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter/material.dart';
import 'swipe_feed_page.dart';
import 'package:flutter/material.dart';
import 'cards_section_alignment.dart';
import 'cards_section_draggable.dart';
import  'image_post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main.dart';
import 'dart:async';
import 'profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'comment_screen.dart';

bool showAlignmentCards = false;
/*

return Scaffold(
appBar: AppBar(
title: const Text('Ding-Ding',
style: const TextStyle(
fontFamily: "Billabong", color: Colors.black, fontSize: 35.0)),
centerTitle: true,
backgroundColor: Colors.white,
),
body: RefreshIndicator(
onRefresh: _refresh,
child: buildFeed(),
),
);
*/
class Feed extends StatefulWidget {




  _Feed createState() => _Feed();







}

class _Feed extends State<Feed> with AutomaticKeepAliveClientMixin<Feed>{
  Future<QuerySnapshot> userDocs;
  bool showAlignmentCards = false;
  buildSearchField() {
    submit("");
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text('Ding-Ding',
          style: const TextStyle(
              fontFamily: "Billabong", color: Colors.black, fontSize: 35.0)),
      centerTitle: true,
    );

  }

  ListView buildSearchResults(List<DocumentSnapshot> docs) {
    List<UserSearchItem> userSearchItems = [];

    docs.forEach((DocumentSnapshot doc) {
      User user = User.fromDocument(doc);
      UserSearchItem searchItem = UserSearchItem(user);
      userSearchItems.add(searchItem);
    });

    return ListView(
      children: userSearchItems,
    );
  }
String searchValue = " ";
  void submit(searchValue) async {
    Future<QuerySnapshot> users = Firestore.instance
        .collection("insta_users")
        .where('displayName', isGreaterThanOrEqualTo: searchValue)
        .getDocuments();

    setState(() {
      userDocs = users;
    });
  }

  Widget build(BuildContext context) {
    CardController controller;
    super.build(context); // reloads state when opened again

    return Scaffold(
      appBar: buildSearchField(),
      body: userDocs == null
          ? Text("")
          : FutureBuilder<QuerySnapshot>(
          future: userDocs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildSearchResults(snapshot.data.documents);
            } else {
              return Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator()
              );
            }
          }),
    );
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}

class UserSearchItem extends StatelessWidget {
  final User user;
  final int cardNum = 0;
  const UserSearchItem(this.user);



  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

     return SingleChildScrollView(

     child:  new Center(

       child:GestureDetector(

      child: new AspectRatio(
        aspectRatio: 330 / 400,

        child: new Container(

            decoration: new BoxDecoration(

              image: new DecorationImage(

                fit: BoxFit.fitWidth,
                alignment: FractionalOffset.topCenter,
                image: new NetworkImage(user.photoUrl),

              )


          ),

        ),


      ),

           onTap: () {
             addActivityFeedItem();
           }

       ),

       ),

     );

  }

  void addActivityFeedItem() {
    print("1111111111111111111");
    print(user.id);
    print(currentUserModel.id);
    Firestore.instance
        .collection("ding_gaurav")
        .document(currentUserModel.id)
        .collection("items")
        .document(user.id)

        .setData({
      "username": currentUserModel.username,
      "userId": currentUserModel.id,
      "liker_name":user.displayName,
      "liker_id":user.id,

      "like":1,
      "type": "like",
      "liker_image":user.photoUrl,
      "userProfileImg": currentUserModel.photoUrl,

      "timestamp": DateTime.now().toString(),

    });
  }


 /* Widget buttonsRow(BuildContext context)
  {
    return new Container
      (
      padding: EdgeInsets.all(65),
      margin: new EdgeInsets.symmetric(vertical: 48.0),
      child: new Row
        (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>
        [
          new FloatingActionButton
            (
            heroTag: "btn1",
            mini: true,
            onPressed: () {},
            backgroundColor: Colors.white,
            child: new Icon(Icons.loop, color: Colors.yellow),
          ),
          new Padding(padding: new EdgeInsets.only(right: 8.0)),
          new FloatingActionButton
            (
            heroTag: "btn2",
            onPressed: () {},
            backgroundColor: Colors.white,
            child: new Icon(Icons.close, color: Colors.red),
          ),
          new Padding(padding: new EdgeInsets.only(right: 8.0)),
          new FloatingActionButton
            (
            onPressed: () {

            },
            heroTag: "btn3",
            backgroundColor: Colors.white,
            child: new Icon(Icons.favorite, color: Colors.green),
          ),
          new Padding(padding: new EdgeInsets.only(right: 8.0)),
          new FloatingActionButton
            (
            heroTag: "btn4  ",
            mini: false,
            onPressed: () {openProfile(context, user.id);},
            backgroundColor: Colors.white,
            child: new Icon(Icons.chat, color: Colors.blue),
          ),
        ],
      ),
    );
  }*/


}



















