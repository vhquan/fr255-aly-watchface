using Toybox.WatchUi;

class beeDanceAnimationController {
    private var _animation;
    private var _playing;

    function initialize() {
        _playing = false;
    }

    function handleOnShow(view) {
        if (view.getLayers() == null) {
            _animation = new WatchUi.AnimationLayer(
                Rez.Drawables.beeDancers,
                {
                    :locX => 6,
                    :locY => 100,
                }
            );

            view.addLayer(_animation);
        }
    }

    function handleOnHide(view) {
        view.clearLayers();
        _animation = null;
    }

    function play() {
        if (!_playing) {
            _animation.play({
                :delegate => new beeDanceAnimationDelegate(self)
            });
            _playing = true;
        }
    }

    function stop() {
        if (_playing) {
            _animation.stop();
            _playing = false;
        }
    }
}