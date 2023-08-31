import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tuwu/components/bullet_component.dart';
import 'package:tuwu/components/bulletboss_component.dart';
import 'package:tuwu/components/explosion_component.dart';
import 'package:tuwu/components/bonus_component.dart';
import 'dart:math';

class BouncingBulletComponent extends BulletBossComponent {
  BouncingBulletComponent({
    required Vector2 position,
    required double angle,
    required double speed,
  }) : super(position: position, angle: angle, speed: speed);

  @override
  void update(double dt) {
    super.update(dt);

    // Vérifie si la balle entre en collision avec les bords de l'écran
    if (position.x < 0 || position.x > gameRef.size.x) {
      angle = -angle; // Change l'angle pour rebondir horizontalement
    }
    if (position.y < 0 || position.y > gameRef.size.y) {
      angle = pi - angle; // Change l'angle pour rebondir verticalement
    }
  }
}
