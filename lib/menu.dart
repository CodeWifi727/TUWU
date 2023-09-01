import 'package:flutter/material.dart';
import 'package:tuwu/rogue_shooter_widget.dart';
import 'package:tuwu/tuwu_game.dart';

class MainMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Supprimez la barre d'applications
      body: GestureDetector(
        onTap: () {
          // Lorsque l'utilisateur appuie sur l'écran, naviguez vers votre jeu
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RogueShooterWidget()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/tuwu/menubackground.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            // Vous pouvez ajouter du contenu ici, comme des titres, des instructions, etc.
            child: Text(
              'Appuyez pour démarrer',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
