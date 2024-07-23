// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, deprecated_member_use



import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../History/history.dart';
import '../bookstest.dart';
import '../models/book.dart';
import '../models/group.dart';
import '../models/user.dart';
import '../review/review.dart';
import '../root/root.dart';
import '../services/database.dart';
import '../splashScreen/splash.dart';
import '../states/current_group.dart';
import '../states/current_user.dart';
import '../utils/imeleft.dart';
import '../widgets/home_books.dart';
import '../widgets/our_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> timeUntil = List.filled(2,
      ""); // [0] The time the book is due, [1] The time the next book is revealed
  late Timer timer;

  void startTimer(CurrentGroup currentGroup) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeUntil = OurTimeLeft()
            .timeleft(currentGroup.getCurrentGroup.currentBookDue.toDate());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    CurrenState currenState = Provider.of<CurrenState>(context, listen: false);
    CurrentGroup currentGroup =
        Provider.of<CurrentGroup>(context, listen: false);
    currentGroup.updateStateFromDatabase(
        currenState.getCurrentUser.groupId, currenState.getCurrentUser.uid);
    startTimer(currentGroup);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void goToAddBook(BuildContext context, String gid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookTest(
                  gid: gid,
                  onGroupCreation: false,
                )));
  }

  void signOut(BuildContext context) async {
    CurrenState currenState = Provider.of(context, listen: false);
    String returnString = await currenState.signOut();
    if (returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const OurRoot(),
          ),
          (route) => false);
    }
  }

  void leaveGroup(
      BuildContext context, String gid, String uid, String name) async {
    String returnString = await OurDatabase().leaveGroup(gid, uid, name);
    if (returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const OurRoot(),
          ),
          (route) => false);
    }
  }

  void deleteGroup(
      BuildContext context, String gid, List<String> members) async {
    String returnString = await OurDatabase().deleteGroup(gid, members);
    if (returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const OurRoot(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentGroup currentGroup =
        Provider.of<CurrentGroup>(context, listen: false);
    CurrenState currenState = Provider.of(context, listen: false);
    OurUser currentUser = currenState.getCurrentUser;
    OurGroup currentG = currentGroup.getCurrentGroup;
    OurBook book = currentGroup.getCurrentBook;

    List<String> names = currentG.memebrsNames;
    List<String> namesId = currentG.memebrs;

    void handleClick(String value) {
      switch (value) {
        case 'Logout':
          signOut(context);
          break;
        case 'Settings':
          break;

        case 'History':
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OurHistory(
                        gid: currentG.id,
                        isowner: currentG.leader == currentUser.uid,
                      )));
          break;
      }
    }

    //get the position of a user click for the drop down option when longClicking on a user in a group
    void _showContextMenu(
        BuildContext context, String userId, String userName) async {
      Rect? rect;
      RenderBox? overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      final renderObject = context.findRenderObject();
      final translation = renderObject?.getTransformTo(null).getTranslation();
      if (translation != null && renderObject?.paintBounds != null) {
        final offset = Offset(translation.x, translation.y);
        rect = renderObject!.paintBounds.shift(offset);
      }

      final result = await showMenu(
          context: context,

          // Show the context menu at the tap location
          position: RelativeRect.fromRect(
            rect!,
            Offset.zero & overlay.size,
          ),

          // set a list of choices for the context menu
          items: [
            const PopupMenuItem(
              value: 'Add Friend',
              child: Text('Add Friend'),
            ),
            const PopupMenuItem(
              value: 'View Profile',
              child: Text('View Profile'),
            ),
            currentG.leader == currentUser.uid
                ? const PopupMenuItem(
                    value: 'Kick',
                    child: Text('Kick'),
                  )
                : const PopupMenuItem(
                    child: Text(''),
                  ),
          ]);

      // Implement the logic for each choice here
      switch (result) {
        case 'Add Friend':
          debugPrint('Add To Favorites');
          break;
        case 'Kick':
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Text('Please Confirm'),
                  content: Text('Are you sure you want to kick ' +
                      userName +
                      " for your club?"),
                  actions: [
                    // The "Yes" button
                    TextButton(
                        onPressed: () async {
                          // Remove the box
                          await OurDatabase()
                              .leaveGroup(currentG.id, userId, userName);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("User has been removed"),
                            duration: Duration(seconds: 2),
                          ));

                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes')),
                    TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'))
                  ],
                );
              });

          break;
        case 'View Profile':
          debugPrint('Hide');
          break;
      }
    }

    return (currentG.id != "" && book.id != "" && names != [])
        ? Scaffold(
            appBar: AppBar(
              title: const Text("Home"),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: const Color.fromARGB(247, 58, 107, 253),
              actions: <Widget>[
                GestureDetector(
                    onTap: () {
                      goToAddBook(context, currentG.id);
                    },
                    child: const Icon(Icons.add)),
                PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {'Settings', 'History', 'Logout'}
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    DrawerHeader(
                      child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(currentG.name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: const Icon(Icons.share),
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                                text: currentG.id))
                                            .then((value) {
                                          //only if ->
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text("Copied Invite Link"),
                                            duration: Duration(seconds: 2),
                                          ));
                                        });
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("Group Members",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: names.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onLongPress: () {
                                    if (namesId[index] != currentUser.uid) {
                                      _showContextMenu(context, namesId[index],
                                          names[index]);
                                    }
                                  },
                                  child: ListTile(
                                    title: Text(names[index]),
                                    leading: Icon(
                                        namesId[index] == currentG.leader
                                            ? Icons.star
                                            : Icons.person),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black,
                                )
                              ],
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                          child: Text(
                            currentUser.uid == currentG.leader
                                ? "Delete Group"
                                : "Leave Group",
                            style: const TextStyle(color: Colors.red),
                          ),
                          
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return AlertDialog(
                                    title: const Text('Please Confirm'),
                                    content: Text(currentUser.uid ==
                                            currentG.leader
                                        ? "Are you sure you want to delete the group?"
                                        : "Are you sure you want to leave the group?"),
                                    actions: [
                                      // The "Yes" button
                                      TextButton(
                                          onPressed: () async {
                                            // Remove the box
                                            currentUser.uid == currentG.leader
                                                ? deleteGroup(
                                                    context,
                                                    currentG.id,
                                                    currentG.memebrs)
                                                : leaveGroup(
                                                    context,
                                                    currentG.id,
                                                    currentUser.uid,
                                                    currentUser.fullname);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(currentUser.uid ==
                                                      currentG.leader
                                                  ? "BookClub deleted"
                                                  : "Success"),
                                              duration: const Duration(seconds: 2),
                                            ));

                                            // Close the dialog
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Yes')),
                                      TextButton(
                                          onPressed: () {
                                            // Close the dialog
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('No'))
                                    ],
                                  );
                                });
                          }),
                    )
                  ],
                ),
              ),
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc((currentG.id))
                  .collection("books")
                  .doc(book.id)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return const OurSplashScreen();
                }

                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('groups')
                        .doc((currentG.id))
                        .collection("books")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot2) {
                      if (!snapshot2.hasData) {
                        return const OurSplashScreen();
                      }
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: OurContainer(
                              child: Consumer<CurrentGroup>(
                                builder: (BuildContext context, value,
                                    Widget? child) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image(
                                                  image: NetworkImage(
                                                      snapshot.data['image']))),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: 160,
                                                  child: Text(
                                                    (snapshot.data['name'] !=
                                                            "")
                                                        ? snapshot.data['name']
                                                        : "Loading...",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.grey),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                  ),
                                                ),
                                                Text(
                                                  (snapshot.data['author'] !=
                                                          "")
                                                      ? snapshot.data['author']
                                                      : "Loading...",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Due In:",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                (timeUntil[0] != null)
                                                    ? timeUntil[0]
                                                    : "Loading...",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                softWrap: false,
                                                maxLines: 2,
                                                overflow: TextOverflow.fade,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              doprivacy(currentG.bookLink);
                                            },
                                            child: const Text(
                                              "Read",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              value.getDoneWithCurrentBook
                                                  ? null
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OurReview(
                                                                currentGroup:
                                                                    currentGroup,
                                                                userName:
                                                                    currentUser
                                                                        .fullname,
                                                                uid: currentUser
                                                                    .uid,
                                                                bookName:
                                                                    book.name,
                                                                image:
                                                                    book.image,
                                                                author:
                                                                    book.author,
                                                              )));
                                            
                                            },
                                            child: const Text(
                                              "Finished Book",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const OurRoot(),
                                              ),
                                              (route) => false);
                                        },
                                        child: const Text(
                                          "Refresh",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const Text(
                            "Current Books",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot2.data?.docs.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  final document = snapshot2.data?.docs[index];

                                  if (document != null) {
                                    return HomeBooks(
                                      name: document["name"],
                                      author: document["author"],
                                      pages: document["length"],
                                      categories: const [""],
                                      image: document["image"],
                                      gid: currentG.id,
                                      bid: document.id,
                                      isowner:
                                          currentUser.uid == currentG.leader
                                              ? true
                                              : false,
                                    );
                                  }

                                  return const HomeBooks(
                                    name: "",
                                    author: "",
                                    pages: "0",
                                    categories: [""],
                                    image: "",
                                    gid: "",
                                    bid: "",
                                    isowner: false,
                                  );
                                }),
                          ),
                        ],
                      );
                    });
              },
            ))
        : const OurSplashScreen();
  }

  Future<void> doprivacy(String link) async {
    String url = link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Couldn't launch link"),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
