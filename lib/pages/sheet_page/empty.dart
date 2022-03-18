import 'package:flutter/material.dart';

class Empty extends StatefulWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  State<Empty> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rotateController;

  @override
  @protected
  @mustCallSuper
  void deactivate() {
    _animationController.stop();
    _rotateController.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
    _rotateController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget emptyList() {
      /*
    This function returns a page in case of new page.
    when there is no data,it returns an icon.
    */
      Animation _sizeAnimation = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
              tween: Tween(begin: 100, end: 120), weight: 50),
          TweenSequenceItem<double>(
              tween: Tween(begin: 120, end: 100), weight: 50),
        ],
      ).animate(_animationController);

      Animation<double> _rotate =
          Tween<double>(begin: 0, end: 1).animate(_rotateController);
      Animation _revSizeAnimation = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
              tween: Tween(begin: 400, end: 300), weight: 50),
          TweenSequenceItem<double>(
              tween: Tween(begin: 300, end: 400), weight: 50),
        ],
      ).animate(_rotateController);

      return Expanded(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _rotateController,
              builder: (_, child) {
                return Center(
                  child: RotationTransition(
                    turns: _rotate,
                    child: ImageIcon(
                      const AssetImage("assets/images/could.png"),
                      size: _revSizeAnimation.value,
                      color: Theme.of(context).primaryColor.withOpacity(.1),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) {
                return Center(
                  child: ImageIcon(
                    const AssetImage("assets/images/credit-card1.png"),
                    size: _sizeAnimation.value,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    return emptyList();
  }
}
