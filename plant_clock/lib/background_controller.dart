import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';

class BackgroundController extends FlareController {

  String _night = "night";
  String _day = "day";

  FlutterActorArtboard _artboard;
  ActorAnimation _anim;
  double _time = 0.0;
  double _speed = 0.5;
  bool isNight;

  BackgroundController(this.isNight);


  @override
  void initialize(FlutterActorArtboard artboard) {
    _artboard = artboard;
    _anim = _artboard.getAnimation(isNight?_night:_day);
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    bool isAnimCompleted = _time * _anim.duration > _anim.duration;
    if (isNight == true && _anim.name != _night && isAnimCompleted) {
      _time = 0;
      _anim = _artboard.getAnimation(_night);
    } else if (isNight == false && _anim.name != _day && isAnimCompleted) {
      _time = 0;
      _anim = _artboard.getAnimation(_day);
    }
    _time += elapsed * _speed;
    _anim.apply(_time * _anim.duration, artboard, 1);
    return true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}
}