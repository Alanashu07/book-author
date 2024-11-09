import 'package:book_author/Widgets/Loading/image_loader.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AuthorTileLoading extends StatelessWidget {
  const AuthorTileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              )
            ),
          ),
          const SizedBox(width: 10,),
          const Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageLoader(width: double.infinity, height: 18,),
              SizedBox(height: 15,),
              ImageLoader(width: double.infinity, height: 14,),
              SizedBox(height: 5,),
              ImageLoader(width: double.infinity, height: 14,),
            ],
          ))
        ],
      ),
    );
  }
}
