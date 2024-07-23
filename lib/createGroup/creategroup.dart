
import 'package:flutter/material.dart';
import 'package:laban_m_study/bookstest.dart';
import 'package:laban_m_study/widgets/our_container.dart';

class OurCreateGroup extends StatefulWidget {
  const OurCreateGroup({Key? key}) : super(key: key);

  @override
  State<OurCreateGroup> createState() => _OurCreateGroupState();
}

class _OurCreateGroupState extends State<OurCreateGroup> {
  void goToAddBook(BuildContext context, String groupName) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookTest(
                  gid: groupName,
                  onGroupCreation: true,
                )));
  }

  TextEditingController groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const [BackButton()],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: OurContainer(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: groupNameController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.group),
                              hintText: "Group Name"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            goToAddBook(
                                context, groupNameController.text.trim());
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            child: Text(
                              "Create",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
