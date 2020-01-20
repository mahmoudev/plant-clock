import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';

class PlantController extends FlareController {

  FlutterActorArtboard _artboard;
  ActorAnimation _anim;
  double _time = 0.0;
  double _speed = 0.3;
  int _prevCounter = -1;
  int counter = 0;

  PlantController();

  @override
  void initialize(FlutterActorArtboard artboard) {
    _artboard = artboard;
    _anim = null;

  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if(counter == _prevCounter){
      if(_anim != null) {
        if (_time > _anim.duration) {

          _anim = null;
        }
      }
    }else{
      _prevCounter = counter;
      _time = 0.0;
      if(counter == 0){
        _anim = _artboard.getAnimation("falling");
      }else{
        _anim = _artboard.getAnimation("num_$counter");
      }
    }
    if(_anim != null){
      _time += elapsed * _speed;
      _anim.apply(_time * _anim.duration, artboard, 1);
    }
    return true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
  }

}
