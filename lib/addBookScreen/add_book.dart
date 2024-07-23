// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:laban_m_study/models/book.dart';
import 'package:laban_m_study/models/user.dart';
import 'package:laban_m_study/root/root.dart';
import 'package:laban_m_study/services/database.dart';
import 'package:laban_m_study/states/current_user.dart';
import 'package:laban_m_study/widgets/our_container.dart';
import 'package:provider/provider.dart';

class OurAddBook extends StatefulWidget {
  final bool onGroupCreation;
  final String groupName;
  final String name;
  final String author;
  final String length;
  final String bookLink;
  final String image;
  const OurAddBook(
      {Key? key,
      required this.groupName,
      required this.onGroupCreation,
      required this.bookLink,
      required this.name,
      required this.length,
      required this.author,
      required this.image})
      : super(key: key);

  @override
  State<OurAddBook> createState() => _OurAddBookState();
}

class _OurAddBookState extends State<OurAddBook> {
  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked =
        await DatePicker.showDateTimePicker(context, showTitleActions: true);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void addBook(BuildContext context, String groupName, OurBook book) async {
    CurrenState currenState = Provider.of<CurrenState>(context, listen: false);
    OurUser us = currenState.getCurrentUser;
    String returnString;
    if (widget.onGroupCreation) {
      returnString =
          await OurDatabase().createGroup(groupName, us.uid, book, us.fullname);
    } else {
      returnString = await OurDatabase().addBook(us.groupId, book, false);
    }
    if (returnString == "success") {
      // OurRoot
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OurRoot()));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController bookNameController =
        TextEditingController(text: widget.name);
    TextEditingController authorController =
        TextEditingController(text: widget.author);
    TextEditingController lengthController =
        TextEditingController(text: widget.length);
    TextEditingController linkCoontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Book",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(247, 63, 101, 214),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: OurContainer(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: bookNameController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.book),
                            hintText: "Book Name"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: authorController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.group), hintText: "Author"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: lengthController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          hintText: "Length",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: linkCoontroller,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.link),
                          hintText: "Book Link",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //datepicker
                      Text(DateFormat.yMMMd("en_US").format(selectedDate)),
                      Text("${selectedDate.hour}:${selectedDate.minute}"),
                      TextButton(
                          onPressed: () {
                            selectDate(context);
                          },
                          child: const Text("Change Date")),

                      ElevatedButton(
                        onPressed: () {
                          OurBook book = OurBook(
                              id: widget.groupName,
                              name: bookNameController.text.trim(),
                              length: lengthController.text.trim(),
                              dateCompleted: Timestamp.fromDate(selectedDate),
                              author: authorController.text.trim(),
                              image: widget.image,
                              bookLink: linkCoontroller.text.trim());
                          addBook(context, widget.groupName, book);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          child: Text(
                            "Add Book",
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
          )
        ],
      ),
    );
  }
}
