import 'dart:math';

import 'package:flame/components.dart';
import 'package:tuwu/components/bonus_component.dart';

class BonusCreator extends TimerComponent with HasGameRef {
  final Random random = Random();
  final _halfWidth = BonusComponent.initialSize.x / 2;

  BonusCreator() : super(period: 20, repeat: true);

  @override
  void onTick() {
    gameRef.addAll(
      List.generate(
        5,
        (index) => BonusComponent(
          position: Vector2(
            _halfWidth + (gameRef.size.x - _halfWidth) * random.nextDouble(),
            0,
          ),
        ),
      ),
    );
  }
}