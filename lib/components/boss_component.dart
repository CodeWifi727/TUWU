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
  double health = 1000;
  int currentPhase = 1; // Phase initiale
  Vector2 velocity = Vector2(0, 0); // Vélocité du boss
  Random random = Random();
  double changeDirectionInterval = 2.0; // Intervalles pour changer de direction
  double timeUntilChangeDirection = 0;

  // Définissez les seuils de transition de phase ici
  final Map<int, int> phaseThresholds = {
    1: 750, // Phase 1 : 1000 HP à 751 HP
    2: 500, // Phase 2 : 750 HP à 501 HP
    3: 250, // Phase 3 : 500 HP à 251 HP
  };

  final List<List<double>> bulletPatterns = [
    [-2.5, -2.3, -2.0, -2.3, -2.5, -2.1, -2.2, -2.6, -2.7], // Pattern 1
    [1.0, 0.8, 1.5, 0.7, 1.2, 1.1, 1.3], // Pattern 2
    // Ajoutez d'autres patterns si nécessaire
  ];

  final List<double> bulletSpeeds = [0.05, 0.08, 0.1]; // Vitesses pour chaque pattern
  final List<double> bulletIntervals = [0.5, 0.3, 0.2]; // Intervalles entre les tirs pour chaque pattern

  int currentPatternIndex = 0;
  double currentPatternTime = 0;
  double patternChangeInterval = 5;

  BossComponent()
      : super(
          size: Vector2(64, 79),
          position: Vector2(650, 100),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    animation = await gameRef.loadSpriteAnimation(
      'tuwu/boss.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.7,
        amount: 6,
        textureSize: Vector2(64, 79),
      ),
    );

    add(CircleHitbox(collisionType: CollisionType.active));
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

  @override
  void update(double dt) {
    super.update(dt);

    // Mettez à jour la phase en fonction de la santé actuelle
  for (var entry in phaseThresholds.entries) {
    var phase = entry.key;
    var threshold = entry.value;

    if (health <= threshold && currentPhase != phase) {
      currentPhase = phase;
      onPhaseChange(currentPhase); // Appel de la méthode de changement de phase
    }
  }

    // Gestion du changement de direction
    timeUntilChangeDirection -= dt;
    if (timeUntilChangeDirection <= 0) {
      changeDirection();
      timeUntilChangeDirection = random.nextDouble() * changeDirectionInterval;
    }

    // Appliquer la vélocité pour le déplacement fluide
    position += velocity * dt;

    // Limiter le déplacement en hauteur (entre 0 et 400)
    if (position.y < 30) {
      position.y = 30;
      velocity.y = -velocity.y; // Inverser la vélocité en cas de collision
    } else if (position.y > 300) {
      position.y = 300;
      velocity.y = -velocity.y; // Inverser la vélocité en cas de collision
    }

    // Limiter le déplacement en longueur (entre 0 et 1200)
    if (position.x < 30) {
      position.x = 30;
      velocity.x = -velocity.x; // Inverser la vélocité en cas de collision
    } else if (position.x > 1200) {
      position.x = 1200;
      velocity.x = -velocity.x; // Inverser la vélocité en cas de collision
    }

    // Gestion du tir automatique
    currentPatternTime += dt;
    if (currentPatternTime >= bulletIntervals[currentPatternIndex]) {
      _createAutoBullet();
      currentPatternTime = 0;
    }
  }

  void onPhaseChange(int newPhase) {
    // Implémentez les changements spécifiques à chaque phase ici
    // Vous pouvez ajuster les modèles de tir, les comportements, etc.
    // en fonction de la nouvelle phase.
    switch (newPhase) {
      case 1:
        // Phase 1
        break;
      case 2:
        // Phase 2
        break;
      case 3:
        // Phase 3
        break;
      case 4:
        // Phase 4 (Fin du boss)
        break;
      default:
        break;
    }
  }

  void changeDirection() {
    // Changer la vélocité de manière aléatoire
    final newAngle = random.nextDouble() * 2 * pi;
    final speed = random.nextDouble() * 100; // Vitesse aléatoire
    velocity = Vector2(cos(newAngle) * speed, sin(newAngle) * speed);
  }

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

    currentPatternIndex = (currentPatternIndex + 1) % bulletPatterns.length;
  }

  void takeHit() {
    health -= 1; // Réduis la santé du boss
    if (health <= 0) {
      removeFromParent();
      gameRef.add(ExplosionComponent(position: position));
    }
  }
}