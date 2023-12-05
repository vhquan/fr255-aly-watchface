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
    dc.drawRectangle(locX, locY, width, height);
    dc.setColor(color, color);
    dc.fillRectangle(locX + 3, locY + 3, (width - 6) * percentage, height - 6);
  }
}

class BatteryBar extends WatchUi.Drawable {
  hidden var locX, locY, width, height, radius, percentage;

  function initialize(params) {
    Drawable.initialize(params);

    locX = params.get( : locX);
    locY = params.get( : locY);
    width = params.get( : width);
    height = params.get( : height);
    radius = params.get( : radius);
    percentage = 0.0;
  }

  function setPercent(value) { percentage = clamp(value, 1.0, 0.0); }

  function draw(dc) {
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
    dc.drawRoundedRectangle(locX, locY, width, height, radius);
    dc.fillRoundedRectangle(locX + width, locY + height / 6, 3, height / 1.5,
                            radius);
    dc.drawLine(locX - 7, locY, locX - 7, locY + 69);
    if (percentage <= 0.06) {
      dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
    } else {
      dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
    }
    dc.fillRoundedRectangle(locX + 3, locY + 3, (width - 6) * percentage,
                            height - 6, radius);
  }
}

class InverseHorizontalProgressBar extends WatchUi.Drawable {
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
    dc.fillRoundedRectangle(locX + (1 - percentage) * width, locY,
                            width * percentage, height, 6);
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
                            height * percentage, 6);
  }
}