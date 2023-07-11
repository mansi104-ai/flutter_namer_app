import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[]; // added a new property to MyAppState called favorites. This property is initialized with an empty list:[]

  void toggleFavorite(){   
    // toggleFavorite which either removes the current word pair from the list of favorites(if it's already there)
    // or adds it if it isn't there yet.
    // In either casethe code calls notifyListeners(); afterwards.
    if (favorites.contains(current)){
      favorites.remove(current);
    }else{
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;  

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // This centers the children inside the Column along its main (vertical) axis.
         
          children: [
            BigCard(pair: pair),
            SizedBox(height:10),
            Row(
              mainAxisSize: MainAxisSize.min,//use mainAxisSize. This tells Row not to take all available horizontal space.
              children: [

                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: (){
                    appState.getNext();  //this instead of print;
                  },
                  child: Text('Next'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);  
   // requests the app's current theme with Theme.of(context)

    final style = theme.textTheme.displayMedium!.copyWith( // By using the theme.textTheme, you access the app's font theme.
    //the displayMedium property is a large style meant for display text. It says that "display styles
    // are reserved for short, importnant text"- exactly our use case.
    // Calling copyWith() on displayMedium returns a copy of the text style with the changes you define . In this case you are changong only text's color.
     
      color: theme.colorScheme.onPrimary,// to get the new color , you once again acces the app's theme.
      // The color scheme's onPrimary property defines a color that is a good fit for use on the app's primary color.
    );
    return Card(
      color: theme.colorScheme.primary, //defines the card's color to be the same as the theme's colorScheme property.
      // The color scheme contains many colors and primary is the most prominent , defining color of the app.
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
          ),
      ),
    );
  }
}