import 'package:book_author/Constants/routes.dart';
import 'package:book_author/Services/preferences.dart';
import 'package:book_author/State/BookDetailsState/book_details_bloc.dart';
import 'package:book_author/State/RatingState/rating_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'State/AuthorState/Bloc/authors_screen_bloc.dart';
import 'State/BookState/Bloc/books_screen_bloc.dart';
import 'package:http/http.dart' as http;

String jwt = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPrefs();
  jwt = Preferences.getJWT();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              BooksScreenBloc(httpClient: http.Client(), limit: 10),
        ),
        BlocProvider(
          create: (context) => AuthorsScreenBloc(httpClient: http.Client()),
        ),
        BlocProvider(
          create: (context) => BookDetailsBloc(httpClient: http.Client()),
        ),
        BlocProvider(
          create: (context) => RatingBloc(httpClient: http.Client()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: Routes.router,
        title: 'Book & Author',
        darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[900],
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[900], foregroundColor: Colors.white),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          fontFamily: GoogleFonts.inter(color: Colors.white).fontFamily,
          textTheme: GoogleFonts.interTextTheme(const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white))),
          useMaterial3: true,
        ),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          fontFamily: GoogleFonts.inter().fontFamily,
          textTheme: GoogleFonts.interTextTheme(),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
