import 'dart:ffi';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tuwu/components/explosion_component.dart';
import 'package:tuwu/tuwu_game.dart';

class BonusComponent extends SpriteAnimationComponent
    with HasGameRef<RogueShooterGame>, CollisionCallbacks {
  static const speed = 15;
  static final Vector2 initialSize = Vector2.all(25);
  static double bulletspeed = 0.05;


  BonusComponent({required super.position})
      : super(size: initialSize, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    animation = await gameRef.loadSpriteAnimation(
      'tuwu/bonus.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2.all(16),
      ),
    );
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;
    if (y >= gameRef.size.y) {
      removeFromParent();
    }
  }

  void takeHit() {
    removeFromParent();

    gameRef.add(ExplosionComponent(position: position));
    bulletspeed = bulletspeed - 0.05;
    print(bulletspeed);
  }
}