import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:laban_m_study/widgets/our_container.dart';

class ReviewLine extends StatelessWidget {
  final String name;
  final String review;
  final double rating;
  final String gid;
  final String bid;
  const ReviewLine({Key? key,
  required this.name,
    required this.review,
    required this.rating,
    required this.gid,
    required this.bid
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8),
    child: OurContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              RatingBarIndicator(
                rating: rating,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 30.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Text(review,style: const TextStyle( fontSize: 18),maxLines: 10,overflow: TextOverflow.ellipsis,),

        ],
      ),
    ),

    );
  }
}
