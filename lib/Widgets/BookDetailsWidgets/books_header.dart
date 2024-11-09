import 'package:book_author/Constants/format_date.dart';
import 'package:book_author/Models/book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Models/author_model.dart';
import '../../State/AuthorState/Bloc/authors_screen_bloc.dart';
import '../../State/AuthorState/Bloc/authors_screen_states.dart';
import '../../Style/app_style.dart';

class BooksHeader extends StatefulWidget {
  final Book book;

  const BooksHeader({super.key, required this.book});

  @override
  State<BooksHeader> createState() => _BooksHeaderState();
}

class _BooksHeaderState extends State<BooksHeader> {
  late Author author;

  double getRating() {
    double rating = 0;
    for (int i = 0; i < widget.book.ratings.length; i++) {

      if(widget.book.ratings[i]['rating'] is String) {
        rating += int.parse(widget.book.ratings[i]['rating']);
      } else {
        rating += widget.book.ratings[i]['rating'];
      }
    }
    return rating / widget.book.ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorsScreenBloc, AuthorsScreenState>(
        bloc: BlocProvider.of<AuthorsScreenBloc>(context),
        builder: (context, state) {
          if (state is AuthorsScreenInitialState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthorsScreenLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthorsScreenLoadedState) {
            author = state.authors
                .firstWhere((author) => author.id == widget.book.authorId);
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book.title,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'by ${author.name}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Published Date: ${FormatDate.format(widget.book.publishedDate)}',
                          style: TextStyle(
                              fontSize: 14, color: isLightTheme(context) ? Colors.black54 : Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: CupertinoColors.systemYellow,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.book.ratings.isEmpty
                              ? '0.0'
                              : getRating()
                              .toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is AuthorsScreenErrorState) {
            return Center(
              child: Text(state.error),
            );
          }
          return const Center(child: Text('Unknown state'));
        });
  }
}
