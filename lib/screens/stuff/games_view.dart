import 'package:flutter/material.dart';
import 'package:vibe_check_snipe_v1/widgets/top_bar.dart';

import '../../widgets/stuff_widgets/games_search.dart';

class Games extends StatelessWidget {
  const Games({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: TopBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "Games",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Molengo",
                        fontSize: 32),
                  ),
                ),
              ),
              GamesSearchPage()
            ],
          ),
        ));
  }
}
