import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MultiChildrenCrossfadeAnimation extends StatefulWidget {
  /// Creates a cross-fade animation widget.
  ///
  /// The [duration] of the animation is the same for all components (fade in,
  /// fade out, and size), and you can pass [Interval]s instead of [Curve]s in
  /// order to have finer control, e.g., creating an overlap between the fades.
  ///
  /// All the arguments other than [key] must be non-null.
  const MultiChildrenCrossfadeAnimation({
    Key key,
//    @required this.firstChild,
//    @required this.secondChild,
    this.firstCurve = Curves.linear,
    this.secondCurve = Curves.linear,
    this.sizeCurve = Curves.linear,
    this.alignment = Alignment.topCenter,
//    @required this.crossFadeState,
    @required this.duration,
    @required this.children,
    @required this.from,
    @required this.to,
    this.layoutBuilder = defaultLayoutBuilder,
  })  :
// assert(firstChild != null),
//        assert(secondChild != null),
        assert(firstCurve != null),
        assert(secondCurve != null),
        assert(sizeCurve != null),
        assert(alignment != null),
//        assert(crossFadeState != null),
        assert(duration != null),
        assert(layoutBuilder != null),
        super(key: key);


  final List<Widget> children;
  final int from;
  final to;

  /// The duration of the whole orchestrated animation.
  final Duration duration;

  /// The fade curve of the first child.
  ///
  /// Defaults to [Curves.linear].
  final Curve firstCurve;

  /// The fade curve of the second child.
  ///
  /// Defaults to [Curves.linear].
  final Curve secondCurve;

  /// The curve of the animation between the two children's sizes.
  ///
  /// Defaults to [Curves.linear].
  final Curve sizeCurve;

  /// How the children should be aligned while the size is animating.
  ///
  /// Defaults to [Alignment.topCenter].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// A builder that positions the [firstChild] and [secondChild] widgets.
  ///
  /// The widget returned by this method is wrapped in an [AnimatedSize].
  ///
  /// By default, this uses [AnimatedCrossFade.defaultLayoutBuilder], which uses
  /// a [Stack] and aligns the `bottomChild` to the top of the stack while
  /// providing the `topChild` as the non-positioned child to fill the provided
  /// constraints. This works well when the [AnimatedCrossFade] is in a position
  /// to change size and when the children are not flexible. However, if the
  /// children are less fussy about their sizes (for example a
  /// [CircularProgressIndicator] inside a [Center]), or if the
  /// [AnimatedCrossFade] is being forced to a particular size, then it can
  /// result in the widgets jumping about when the cross-fade state is changed.
  final AnimatedCrossFadeBuilder layoutBuilder;

  /// The default layout algorithm used by [AnimatedCrossFade].
  ///
  /// The top child is placed in a stack that sizes itself to match the top
  /// child. The bottom child is positioned at the top of the same stack, sized
  /// to fit its width but without forcing the height. The stack is then
  /// clipped.
  ///
  /// This is the default value for [layoutBuilder]. It implements
  /// [AnimatedCrossFadeBuilder].
  static Widget defaultLayoutBuilder(Widget topChild, Key topChildKey,
      Widget bottomChild, Key bottomChildKey) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          key: bottomChildKey,
          child: bottomChild,
        ),
        Positioned(
          key: topChildKey,
          child: topChild,
        )
      ],
    );
  }

  @override
  _AnimatedCrossFadeState createState() => _AnimatedCrossFadeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
//    properties.add(EnumProperty<CrossFadeState>('crossFadeState', crossFadeState));
    properties.add(DiagnosticsProperty<AlignmentGeometry>(
        'alignment', alignment,
        defaultValue: Alignment.topCenter));
  }
}

class _AnimatedCrossFadeState extends State<MultiChildrenCrossfadeAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _firstAnimation;
  Animation<double> _secondAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
//    if (widget.crossFadeState == CrossFadeState.showSecond)
    _controller.value = 0.0;
    _firstAnimation = _initAnimation(widget.firstCurve, true);
    _secondAnimation = _initAnimation(widget.secondCurve, false);
    _controller.addStatusListener((AnimationStatus status) {
      setState(() {
        // Trigger a rebuild because it depends on _isTransitioning, which
        // changes its value together with animation status.
      });
    });
  }

  Animation<double> _initAnimation(Curve curve, bool inverted) {
    Animation<double> result = _controller.drive(CurveTween(curve: curve));
    if (inverted) result = result.drive(Tween<double>(begin: 1.0, end: 0.0));
    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MultiChildrenCrossfadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration)
      _controller.duration = widget.duration;
    if (widget.firstCurve != oldWidget.firstCurve)
      _firstAnimation = _initAnimation(widget.firstCurve, true);
    if (widget.secondCurve != oldWidget.secondCurve)
      _secondAnimation = _initAnimation(widget.secondCurve, false);
    if (widget.from != oldWidget.from && widget.to != oldWidget.to) {
      _controller.value = 0;
      _controller.forward();
    }
  }

  /// Whether we're in the middle of cross-fading this frame.
  bool get _isTransitioning =>
      _controller.status == AnimationStatus.forward ||
      _controller.status == AnimationStatus.reverse;

  @override
  Widget build(BuildContext context) {
    const Key kFirstChildKey =
        ValueKey<CrossFadeState>(CrossFadeState.showFirst);
    const Key kSecondChildKey =
        ValueKey<CrossFadeState>(CrossFadeState.showSecond);
    final bool transitioningForwards =
        _controller.status == AnimationStatus.completed ||
            _controller.status == AnimationStatus.forward;
    Key topKey;
    Widget topChild;
    Animation<double> topAnimation;
    Key bottomKey;
    Widget bottomChild;
    Animation<double> bottomAnimation;
    topKey = kSecondChildKey;
    topChild = widget.children[widget.to];
    topAnimation = _secondAnimation;
    bottomKey = kFirstChildKey;
    bottomChild = widget.children[widget.from];
    bottomAnimation = _firstAnimation;

    if(bottomChild == topChild){
      return bottomChild;
    }

    bottomChild = TickerMode(
      key: bottomKey,
      enabled: _isTransitioning,
      child: ExcludeSemantics(
        excluding: true,
        // Always exclude the semantics of the widget that's fading out.
        child: FadeTransition(
          opacity: bottomAnimation,
          child: bottomChild,
        ),
      ),
    );
    topChild = TickerMode(
      key: topKey,
      enabled: true, // Top widget always has its animations enabled.
      child: ExcludeSemantics(
        excluding: false,
        // Always publish semantics for the widget that's fading in.
        child: FadeTransition(
          opacity: topAnimation,
          child: topChild,
        ),
      ),
    );
    return ClipRect(
      child: AnimatedSize(
        alignment: widget.alignment,
        duration: widget.duration,
        curve: widget.sizeCurve,
        vsync: this,
        child: widget.layoutBuilder(topChild, topKey, bottomChild, bottomKey),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<AnimationController>(
        'controller', _controller,
        showName: false));
    description.add(DiagnosticsProperty<AlignmentGeometry>(
        'alignment', widget.alignment,
        defaultValue: Alignment.topCenter));
  }
}
