import 'package:flutter/material.dart';

class HoverCard extends StatefulWidget {
  final Widget Function(BuildContext context, bool isHovered) builder;
  final double depth;
  final Color depthColor;
  final VoidCallback onTap;

  const HoverCard({
    Key key,
    @required this.builder,
    this.depthColor = const Color(0xFF424242),
    this.depth = 1,
    this.onTap,
  }) : super(key: key);

  @override
  HoverCardState createState() => HoverCardState();
}

class HoverCardState extends State<HoverCard> with SingleTickerProviderStateMixin {
  double localX = 0;
  double localY = 0;
  bool defaultPosition = true;
  bool isHover = false;
  AnimationController animationController;
  Animation<FractionalOffset> animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  void _resetAnimation(Size size, Offset offset) {
    animationController.addListener(_updatePosition);
    animation = FractionalOffsetTween(
      begin: FractionalOffset(offset.dx, offset.dy),
      end: FractionalOffset((size.width) / 2, (size.height) / 2),
    ).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: animationController,
    ));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => defaultPosition = true);
        animationController.removeListener(_updatePosition);
        animationController.reverse();
      }
    });
  }

  void _updatePosition() {
    setState(() {
      localX = animation.value.dx;
      localY = animation.value.dy;
    });
  }

  void reset(Size size) {
    _resetAnimation(size, Offset(0, 0));
    _updatePosition();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, dimens) {
        final size = Size(dimens.maxWidth, dimens.maxHeight);
        double percentageX = (localX / size.width) * 100;
        double percentageY = (localY / size.height) * 100;
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(defaultPosition ? 0 : (0.3 * (percentageY / 50) + -0.3))
            ..rotateY(defaultPosition ? 0 : (-0.3 * (percentageX / 50) + 0.3)),
          alignment: FractionalOffset.center,
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: widget.depthColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 60),
                  color: Color.fromARGB(120, 0, 0, 0),
                  blurRadius: 22,
                  spreadRadius: -20,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: widget?.onTap,
              child: MouseRegion(
                onEnter: (_) {
                  if (mounted)
                    setState(() {
                      isHover = true;
                      defaultPosition = false;
                    });
                },
                onExit: (_) {
                  if (mounted)
                    setState(() {
                      isHover = false;
                    });
                  _resetAnimation(size, Offset(localX, localY));
                  animationController.forward();
                },
                onHover: (details) {
                  RenderBox box = context.findRenderObject();
                  final _offset = box.globalToLocal(details.localPosition);
                  if (mounted)
                    setState(() {
                      defaultPosition = false;
                      if (_offset.dx > 0 && _offset.dy > 0) {
                        if (_offset.dx < size.width * 1.5 && _offset.dy > 0) {
                          localX = _offset.dx;
                          localY = _offset.dy;
                        }
                      }
                    });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Color(0xFFCCCCCC),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(defaultPosition ? 0.0 : (widget.depth * (percentageX / 50) + -widget.depth),
                                  defaultPosition ? 0.0 : (widget.depth * (percentageY / 50) + -widget.depth), 0.0),
                            alignment: FractionalOffset.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: widget.builder(context, isHover),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Transform(
                              transform: Matrix4.translationValues(
                                (size.width / 2) - localX,
                                (size.height - 50) - localY,
                                0.0,
                              ),
                              child: AnimatedOpacity(
                                opacity: defaultPosition ? 0 : 1,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.decelerate,
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.22),
                                      blurRadius: 100,
                                      spreadRadius: 40,
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
