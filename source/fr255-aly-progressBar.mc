import Toybox.WatchUi;
import Toybox.Graphics;

function clamp(value, max, min) {
  if (value > max) {
    return max;
  } else if (value < min) {
    return min;
  }

  return value;
}

class HorizontalProgressBar extends WatchUi.Drawable {
  hidden var color, locX, locY, width, height, percentage;

  function initialize(params) {
    Drawable.initialize(params);

    color = params.get( : color);
    locX = params.get( : locX);
    locY = params.get( : locY);
    width = params.get( : width);
    height = params.get( : height);
    percentage = 0.0;
  }

  function setPercent(value) { percentage = clamp(value, 1.0, 0.0); }

  function draw(dc) {
    dc.setColor(color, color);
    dc.fillRoundedRectangle(locX, locY, width * percentage, height, 10);
  }
}

class VerticalProgressBar extends WatchUi.Drawable {
  hidden var color, locX, locY, width, height, percentage;

  function initialize(params) {
    Drawable.initialize(params);

    color = params.get( : color);
    locX = params.get( : locX);
    locY = params.get( : locY);
    width = params.get( : width);
    height = params.get( : height);
    percentage = 0.0;
  }

  function setPercent(value) { percentage = clamp(value, 1.0, 0.0); }

  function draw(dc) {
    dc.setColor(color, color);
    dc.fillRoundedRectangle(locX, locY + height * (1 - percentage), width,
                            height * percentage, 10);
  }
}