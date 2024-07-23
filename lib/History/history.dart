import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laban_m_study/widgets/history_books.dart';

class OurHistory extends StatefulWidget {
  final String gid;
  final bool isowner;
  const OurHistory({Key? key,required this.gid,required this.isowner}) : super(key: key);

  @override
  State<OurHistory> createState() => _OurHistoryState();
}

class _OurHistoryState extends State<OurHistory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('groups').doc((widget.gid))
            .collection("Fbooks").snapshots(),
        builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot2){
          return Scaffold(

            appBar: AppBar(
              title: const Text("Finished Books",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(247, 51, 98, 240),
              elevation: 0.0,
              leading: IconButton(icon: const Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context);
                },),
            ),

            body: Column(
              children: [
                const SizedBox(height: 20,),

                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot2.data?.docs.length,
                      scrollDirection: Axis.vertical,

                      itemBuilder: (context, index){
                        final document = snapshot2.data?.docs[index];

                        if(document!=null){
                          return HistoryBooks(name: document["name"], author: document["author"],pages: document["length"],
                            categories: const [""],image: document["image"],gid: widget.gid,bid: document.id,isowner: widget.isowner,);
                        }

                        return const Center(child: LinearProgressIndicator());
                      }
                  ),
                )

              ],
            ),
          );
        } ,

      ),
    );
  }
}
