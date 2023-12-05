import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class fr255_aly_watchfaceView extends WatchUi.WatchFace {
 private
  var backgroundImg;

  function initialize() {
    WatchFace.initialize();
    backgroundImg = Application.loadResource(Rez.Drawables.BackgroundImg);
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {}

  // Update the view
  function onUpdate(dc as Dc) as Void {
    showTime();
    showDate();

    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);

    // all draws must be drawn after onUpdate()
    // dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
    // dc.fillRectangle(100, 100, 100, 100);
    dc.drawBitmap(0, 0, backgroundImg);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be
  // started here.
  function onExitSleep() as Void {}

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() as Void {}

 private
  function showTime() {
    var mTime = System.getClockTime();
    var timeStr =
        Lang.format("$1$:$2$", [ mTime.hour, mTime.min.format("%02d") ]);
    var timeView = View.findDrawableById("TimeDisplay") as Text;
    timeView.setText(timeStr);
  }

 private
  function showDate() {
    var mDate = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
    var dateStr = Lang.format("$1$, $2$ $3$",
                              [ mDate.day_of_week, mDate.month, mDate.day ]);
    var dateView = View.findDrawableById("DateDisplay") as Text;
    dateView.setText(dateStr);
  }
}
