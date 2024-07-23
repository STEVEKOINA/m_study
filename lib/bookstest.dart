// ignore_for_file: unused_local_variable

import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';
import 'package:laban_m_study/addBookScreen/add_book.dart';
import 'package:laban_m_study/widgets/search_item.dart';

class BookTest extends StatefulWidget {
  final String gid;
  final bool onGroupCreation;
  const BookTest({Key? key, required this.gid, required this.onGroupCreation})
      : super(key: key);

  @override
  State<BookTest> createState() => _BookTestState();
}

class _BookTestState extends State<BookTest> {
  TextEditingController searchEditor = TextEditingController();

  List<Book> searchedBook = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Book",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(247, 68, 107, 223),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: searchEditor,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: "Search"),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                child: const Text("Search"),
                onPressed: () async {
                  searchedBook.clear();
                  final books = await queryBooks(
                    searchEditor.text.trim(),
                    maxResults: 10,
                    printType: PrintType.books,
                    orderBy: OrderBy.relevance,
                    reschemeImageLinks: true,
                  );
                  for (final book in books) {
                    final info = book.info;

                    setState(() {
                      searchedBook.add(book);
                    });
                  }
                }),
            ElevatedButton(
                child: const Text("Add Manually"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OurAddBook(
                                groupName: widget.gid,
                                onGroupCreation: widget.onGroupCreation,
                                bookLink: "",
                                name: "",
                                author: "",
                                length: "",
                                image:
                                    "https://i.postimg.cc/cLQRLt7f/content.jpg",
                              )));
                }),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchedBook.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    Book b = searchedBook[index];
                    Uri? uri = searchedBook[index].info.imageLinks["thumbnail"];

                    return SearchItem(
                      name: b.info.title,
                      author: b.info.authors.isEmpty ? "" : b.info.authors[0],
                      pages: b.info.pageCount.toString(),
                      categories: b.info.categories,
                      image: uri == null
                          ? "https://i.postimg.cc/cLQRLt7f/content.jpg"
                          : uri.toString(),
                      gid: widget.gid,
                      onGroupCreation: widget.onGroupCreation,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
