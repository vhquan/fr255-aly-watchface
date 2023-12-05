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
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_LT_GRAY);
    dc.drawRoundedRectangle(locX, locY, width, height, 10);
    dc.setColor(color, color);
    dc.fillRoundedRectangle(locX + 2, locY + 2, (width - 4) * percentage,
                            height - 4, 10);
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
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_LT_GRAY);
    dc.drawRoundedRectangle(locX, locY, width, height, 10);
    dc.setColor(color, color);
    dc.fillRoundedRectangle(locX + 2, locY + height * (1 - percentage) + 2,
                            width - 4, (height - 4) * percentage, 10);
  }
}