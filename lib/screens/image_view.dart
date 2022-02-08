import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../widgets/shimmer.dart';

class ImageView extends StatefulWidget {
  const ImageView({
    Key? key,
    required this.imageUrl,
    this.placeholder = '',
  }) : super(key: key);
  final String imageUrl;
  final String? placeholder;

  @override
  State<ImageView> createState() => _ImageViewState();
}

final TransformationController _transformationController =
    TransformationController();
Animation<Matrix4>? _animationReset;
AnimationController? _controllerReset;

class _ImageViewState extends State<ImageView> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controllerReset!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Previsualización',
        ),
      ),
      body: InteractiveViewer(
        transformationController: _transformationController,
        onInteractionEnd: (details) => _onInteractionEnd(details),
        onInteractionStart: (details) => _onInteractionStart(details),
        child: Center(
          child: CachedNetworkImage(
            alignment: Alignment.center,
            imageUrl: widget.imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => const ShimmerEffect(),
            errorWidget: (_, __, ___) => Image.asset(
              'assets/icon/icon_foreground.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              opacity: const AlwaysStoppedAnimation(0.2),
            ),
          ),
        ),
      ),
    );
  }
}

void _onAnimateReset() {
  _transformationController.value = _animationReset!.value;
  if (!_controllerReset!.isAnimating) {
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset!.reset();
  }
}

void _animateResetStop() {
  _controllerReset!.stop();
  _animationReset!.removeListener(_onAnimateReset);
  _animationReset = null;
  _controllerReset!.reset();
}

void _onInteractionStart(ScaleStartDetails details) {
  if (_controllerReset!.status == AnimationStatus.forward) {
    _animateResetStop();
  }
}

void _animateResetInitialize() {
  _controllerReset!.reset();
  _animationReset = Matrix4Tween(
    begin: _transformationController.value,
    end: Matrix4.identity(),
  ).animate(_controllerReset!);
  _animationReset!.addListener(_onAnimateReset);
  _controllerReset!.forward();
}

void _onInteractionEnd(ScaleEndDetails details) {
  _animateResetInitialize();
}
