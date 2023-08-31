import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tuwu/components/bullet_component.dart';
import 'package:tuwu/components/bulletboss_component.dart';
import 'package:tuwu/components/explosion_component.dart';
import 'package:tuwu/components/bonus_component.dart';

class BossComponent extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  late TimerComponent bulletCreator;
  double health = 10; // Ajoutez une barre de vie pour le boss

  BossComponent()
      : super(
          size: Vector2(150, 142),
          position: Vector2(650, 100),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    add(
      bulletCreator = TimerComponent(
        period: BonusComponent.bulletspeed,
        repeat: true,
        autoStart: false,
        onTick: _createBullet,
      ),
    );
    animation = await gameRef.loadSpriteAnimation(
      'tuwu/boss.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 6,
        textureSize: Vector2(150, 142),
      ),
    );
  }

  final _bulletAngles = [0.5, 0.3, 0.0, -0.5, -0.3];
  void _createBullet() {
    bulletCreator.timer.start();
    gameRef.addAll(
      _bulletAngles.map(
        (angle) => BulletBossComponent(
          position: position + Vector2(0, -size.y / 2),
          angle: angle,
        ),
      ),
    );
  }

  void takeHit() {
    health -= 10; // Réduisez la vie du boss
    if (health <= 0) {
      removeFromParent();
      gameRef.add(ExplosionComponent(position: position));
    }
  }
}
