import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:laban_m_study/states/current_group.dart';
import 'package:laban_m_study/widgets/our_container.dart';



class OurReview extends StatefulWidget {
  final CurrentGroup currentGroup;
  final String userName;
  final String uid;
  final String bookName;
  final String image;
  final String author;
  const OurReview(
      {Key? key,
      required this.currentGroup,
      required this.userName,
      required this.uid,
      required this.bookName,
      required this.image,
      required this.author})
      : super(key: key);

  @override
  State<OurReview> createState() => _OurReviewState();
}

class _OurReviewState extends State<OurReview> {
  double? dropdownValue = 1;
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Review",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(247, 56, 105, 253),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(image: NetworkImage(widget.image))),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                          width: 200,
                          child: Text(
                            widget.bookName,
                            style: const TextStyle(fontSize: 20, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        widget.author,
                        style: const TextStyle(fontSize: 20, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: OurContainer(
                child: Column(
                  children: [
                    const Text(
                      "Rate this book",
                      style: TextStyle(color: Colors.black),
                    ),
                    RatingBar.builder(
                      initialRating: 1,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        dropdownValue = rating;
                      },
                    ),
                    TextFormField(
                      maxLines: 6,
                      controller: reviewController,
                      decoration: const InputDecoration(hintText: "Add a review"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.currentGroup.finishedBook(
                            widget.uid,
                            dropdownValue!,
                            reviewController.text.trim(),
                            widget.userName);
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100),
                        child: Text(
                          "Review",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
