import 'package:book_author/Models/book_model.dart';
import 'package:book_author/State/AuthorState/Bloc/authors_screen_bloc.dart';
import 'package:book_author/State/AuthorState/Bloc/authors_screen_states.dart';
import 'package:book_author/Style/app_style.dart';
import 'package:book_author/Widgets/Loading/books_grid_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../Models/author_model.dart';
import 'Loading/image_loader.dart';

class BooksGrid extends StatefulWidget {
  final Book book;

  const BooksGrid({super.key, required this.book});

  @override
  State<BooksGrid> createState() => _BooksGridState();
}

class _BooksGridState extends State<BooksGrid> {
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
            return const BooksGridLoader();
          } else if (state is AuthorsScreenLoadingState) {
            return const BooksGridLoader();
          } else if (state is AuthorsScreenLoadedState) {
            author = state.authors
                .firstWhere((author) => author.id == widget.book.authorId);
            return GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/booksDetails/${widget.book.id}');
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black12, width: .4),
                      right: BorderSide(color: Colors.black12, width: .4),
                      left: BorderSide(color: Colors.black12, width: .4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(18.0),
                        child: CachedNetworkImage(
                          imageUrl: widget.book.coverPictureUrl,
                          placeholder: (context, url) => const ImageLoader(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Text(
                      widget.book.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      author.name,
                      style:
                          TextStyle(fontSize: 16, color: isLightTheme(context) ? Colors.black54: Colors.white70),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: CupertinoColors.systemYellow,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.book.ratings.isEmpty
                              ? '0.0'
                              : getRating()
                                  .toStringAsFixed(1),
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '₹ ${widget.book.price}.00',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
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
