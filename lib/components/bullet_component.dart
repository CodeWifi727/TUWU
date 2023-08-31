import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tuwu/components/Boss_component.dart';
import 'package:tuwu/components/bonus_component.dart';
import 'package:tuwu/components/enemy_component.dart';

class BulletComponent extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  static const speed = 500.0;
  late final Vector2 velocity;
  final Vector2 deltaPosition = Vector2.zero();

  BulletComponent({required super.position, super.angle})
      : super(size: Vector2(32, 32));

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    animation = await gameRef.loadSpriteAnimation(
      'tuwu/bullet.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.1,
        amount: 4,
        textureSize: Vector2(32, 32),
      ),
    );
    velocity = Vector2(0, -1)
      ..rotate(angle)
      ..scale(speed);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is EnemyComponent) {
      other.takeHit();
      removeFromParent();
    }
    if (other is BossComponent) {
      print("Bullet hit something!"); 
      other.takeHit(); // Inflige des dégâts au boss
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    deltaPosition
      ..setFrom(velocity)
      ..scale(dt);
    position += deltaPosition;

    if (position.y < 0 ||
        position.x > gameRef.size.x ||
        position.x + size.x < 0) {
      removeFromParent();
    }
  }
  
}