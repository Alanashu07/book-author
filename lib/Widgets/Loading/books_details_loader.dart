import 'package:book_author/Widgets/Loading/image_loader.dart';
import 'package:flutter/material.dart';

class BooksDetailsLoader extends StatelessWidget {
  const BooksDetailsLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ImageLoader(
            height: mq.height * .45,
            width: mq.width,
          ),
          const SizedBox(height: 35,),
          ImageLoader(
            height: mq.height * .05,
            width: mq.width,
          ),
          const SizedBox(height: 35,),
          const Expanded(child: ImageLoader()),
          const SizedBox(height: 15,),
          const Expanded(child: ImageLoader()),
          SizedBox(
            height: mq.height * .02,
          )
        ],
      ),
    );
  }
}
