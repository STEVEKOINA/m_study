// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';
import '../root/root.dart';
import '../states/current_user.dart';
import '../widgets/our_container.dart';

class OurJoinGroup extends StatefulWidget {
  const OurJoinGroup({Key? key}) : super(key: key);

  @override
  State<OurJoinGroup> createState() => _OurJoinGroupState();
}

class _OurJoinGroupState extends State<OurJoinGroup> {
  void joinGroup(BuildContext context, String groupId) async {
    CurrenState currenState = Provider.of<CurrenState>(context, listen: false);
    String returnString = await OurDatabase().joinGroup(groupId,
        currenState.getCurrentUser.uid, currenState.getCurrentUser.fullname);
    if (returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const OurRoot(),
          ),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid Group Link"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  TextEditingController groupIdController = TextEditingController();
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
                          controller: groupIdController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.group),
                              hintText: "Group Id"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            joinGroup(context, groupIdController.text.trim());
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            child: Text(
                              "Join",
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
