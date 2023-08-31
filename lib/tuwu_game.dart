import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:tuwu/components/bonus_creator.dart';
import 'package:tuwu/components/enemy_creator.dart';
import 'package:tuwu/components/player_component.dart';
import 'package:tuwu/components/boss_component.dart';

class RogueShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  static const String description = '''
    A simple space shooter game used for testing performance of the collision
    detection system in Flame.
  ''';

  late final PlayerComponent player;
  late final TextComponent componentCounter;
  late final TextComponent scoreText;
  static double  bulletspeed = 1.0;

  int score = 0;

  @override
  Future<void> onLoad() async {
    final backgroundImage = await images.load('tuwu/background.jpg');
    add(SpriteComponent.fromImage(backgroundImage)
      ..size = size // Assurez-vous que la taille de l'image soit la même que celle de l'écran
    );
    add(BonusCreator());
    add(EnemyCreator());
    add(BossComponent());
    add(player = PlayerComponent());
    addAll([
      FpsTextComponent(
        position: size - Vector2(0, 50),
        anchor: Anchor.bottomRight,
      ),
      scoreText = TextComponent(
        position: size - Vector2(0, 25),
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
      componentCounter = TextComponent(
        position: size,
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    scoreText.text = 'Score: $score';
    componentCounter.text = 'Components: ${children.length}';
  }

  @override
  void onPanStart(_) {
    player.beginFire();
  }

  @override
  void onPanEnd(_) {
    player.stopFire();
  }

  @override
  void onPanCancel() {
    player.stopFire();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.position += info.delta.game;
  }

  void increaseScore() {
    score++;
  }
}