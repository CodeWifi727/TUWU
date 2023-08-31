import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tuwu/components/Boss_component.dart';
import 'package:tuwu/components/bullet_component.dart';
import 'package:tuwu/components/bulletboss_component.dart';
import 'package:tuwu/components/enemy_component.dart';
import 'package:tuwu/components/explosion_component.dart';
import 'package:tuwu/components/bonus_component.dart';

class PlayerComponent extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  late TimerComponent bulletCreator;

  PlayerComponent()
      : super(
          size: Vector2(50, 75),
          position: Vector2(650, 600),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    add(
      bulletCreator = TimerComponent(
        period: BonusComponent.bulletspeedB,
        repeat: true,
        autoStart: false,
        onTick: _createBullet,
      ),
    );
    animation = await gameRef.loadSpriteAnimation(
      'tuwu/player.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2(32, 39),
      ),
    );
  }

  final _bulletAngles = [0.0];
  void _createBullet() {
    gameRef.addAll(
      _bulletAngles.map(
        (angle) => BulletComponent(
          position: position + Vector2(0, -size.y / 2),
          angle: angle,
        ),
      ),
    );
  }

  void beginFire() {
    bulletCreator.timer.start();
  }

  void stopFire() {
    bulletCreator.timer.pause();
  }

  void takeHit() {
    gameRef.add(ExplosionComponent(position: position));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is BonusComponent) {
      other.takeHit();
      if (BonusComponent.bulletspeedB > 0) {
        onLoad();
      }
    }
    if(other is EnemyComponent) {
      print("you dead");
    }
    if (other is BulletBossComponent) {
      print("you dead");
    }
  }
}