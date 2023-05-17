import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mononton_app/view/movie/movie_screen.dart';
import 'package:mononton_app/view/movie/movie_view_model.dart';
import 'package:mononton_app/view/movie/person_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('MyApp Widget Test', ((WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => PersonViewModel(),
        ),
      ],
      child: MaterialApp(
        home: MovieScreen(),
      ),
    ));

    expect(find.text('Movie Screen'), findsOneWidget);
  }));
}
