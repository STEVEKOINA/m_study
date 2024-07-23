import 'package:flutter/material.dart';
import 'package:laban_m_study/createGroup/creategroup.dart';
import 'package:laban_m_study/joinGroup/joingroup.dart';

class OurnoGroup extends StatelessWidget {
  const OurnoGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void goToJoin(BuildContext context) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const OurJoinGroup()));
    }

    void goToCreate(BuildContext context) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const OurCreateGroup()));
    }

    return Scaffold(
      body: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(80),
            child: Image.asset("assets/book.jpg"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Welcome to Book Club",
              style: TextStyle(fontSize: 40, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Since you are not in a book club, you can select to either join or create a club",
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).canvasColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                          color: Theme.of(context).secondaryHeaderColor,
                          width: 2)),
                  ),
                  onPressed: () {
                    goToCreate(context);
                  },
                  child: const Text(
                    "Create",
                  ),
                 
                  
                ),
                ElevatedButton(
                  onPressed: () {
                    goToJoin(context);
                  },
                  child: const Text(
                    "Join",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
