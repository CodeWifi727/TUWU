import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tuwu/components/bouncing_bullet_component.dart';
import 'package:tuwu/components/bullet_component.dart';
import 'package:tuwu/components/bulletboss_component.dart';
import 'package:tuwu/components/explosion_component.dart';
import 'package:tuwu/components/bonus_component.dart';

class BossComponent extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  late TimerComponent autoBulletCreator;
  double health = 1000; // Ajoutez une barre de vie pour le boss

  final List<List<double>> bulletPatterns = [
    [-2.5, -2.3, -2.0, -2.3, -2.5, -2.1, -2.2, -2.6, -2.7], // Pattern 1
    [1.0, 0.8, 1.5, 0.7, 1.2, 1.1, 1.3],                 // Pattern 2
    // Ajoute d'autres patterns si nécessaire
  ];

  final List<double> bulletSpeeds = [0.05, 0.08, 0.1]; // Vitesses pour chaque pattern
  final List<double> bulletIntervals = [0.5, 0.3, 0.2]; // Intervalles entre les tirs pour chaque pattern

  int currentPatternIndex = 0;
  double currentPatternTime = 0;
  double patternChangeInterval = 5;

  BossComponent()
      : super(
          size: Vector2(150, 142),
          position: Vector2(650, 100),
          anchor: Anchor.center,
        );


  @override
  Future<void> onLoad() async {
    size = Vector2(150, 142); // Taille du sprite du boss
    position = Vector2(650, 100); // Position du sprite du boss
    animation = await gameRef.loadSpriteAnimation(
      'tuwu/boss.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 6,
        textureSize: Vector2(150, 142),
      ),
    );
    add(CircleHitbox(collisionType: CollisionType.active));
    add(
      autoBulletCreator = TimerComponent(
        period: 0.5, // Temps en secondes entre chaque tir automatique
        repeat: true,
        autoStart: true,
        onTick: _createAutoBullet,
      ),
    );
  }
  @override
    void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is BulletComponent) {
      takeHit();
      other.removeFromParent();
    }
  }

  final int numberOfBullets = 8; // Nombre de balles à tirer

  void _createAutoBullet() {
    final pattern = bulletPatterns[currentPatternIndex];

    pattern.forEach((angle) {
      final speedIndex = Random().nextInt(bulletSpeeds.length); // Index de vitesse aléatoire
      final speed = bulletSpeeds[speedIndex]; // Vitesse correspondante

      final randomAngleChange = Random().nextDouble() * pi * 2; // Angle aléatoire
      final finalAngle = angle + randomAngleChange;

      gameRef.add(
        BulletBossComponent(
          position: position + Vector2(0, size.y / 2),
          angle: finalAngle,
          speed: speed,
        ),
      );
    });

    pattern.forEach((angle) {
      final speedIndex = Random().nextInt(bulletSpeeds.length);
      final speed = bulletSpeeds[speedIndex];
      gameRef.add(
        BulletBossComponent(
          position: position + Vector2(0, size.y / 2),
          angle: angle,
          speed: speed,
        ),
      );
    });
    pattern.forEach((angle) {
    final speedIndex = Random().nextInt(bulletSpeeds.length);
    final speed = bulletSpeeds[speedIndex];
    final bullet = BouncingBulletComponent(
      position: position + Vector2(0, size.y / 2),
      angle: angle,
      speed: speed,
    );
    gameRef.add(bullet);
  });

    currentPatternTime += 2; // Interval between automatic bullets
    if (currentPatternTime >= patternChangeInterval) {
      currentPatternIndex = (currentPatternIndex + 1) % bulletPatterns.length;
      currentPatternTime = 0;
    }
  }

  void takeHit() {
    health -= 1; // Réduis la santé du boss
    if (health <= 0) {
      removeFromParent();
      gameRef.add(ExplosionComponent(position: position));
    }
  }
}

