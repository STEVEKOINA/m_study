import 'package:flutter/material.dart';
import 'package:laban_m_study/addBookScreen/add_book.dart';
import 'package:laban_m_study/widgets/our_container.dart';

class SearchItem extends StatefulWidget {
  final bool onGroupCreation;
  final String name;
  final String author;
  final String pages;
  final List<String> categories;
  final String image;
  final String gid;

  const SearchItem(
      {Key? key,
      required this.name,
      required this.author,
      required this.pages,
      required this.categories,
      required this.image,
      required this.gid,
      required this.onGroupCreation})
      : super(key: key);

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OurAddBook(
                        groupName: widget.gid,
                        onGroupCreation: widget.onGroupCreation,
                        bookLink: "",
                        name: widget.name,
                        length: widget.pages,
                        author: widget.author,
                        image: widget.image,
                      )));
        },
        child: OurContainer(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(widget.image),
                      height: 80,
                    )),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 160,
                          child: Text(
                            widget.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          )),
                      Text(
                        widget.author,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        "${widget.pages} Pages",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(widget.categories
                .toString()
                .replaceAll('[', "")
                .replaceAll(']', ""))
          ],
        )),
      ),
    );
  }
}
