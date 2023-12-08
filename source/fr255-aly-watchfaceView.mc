import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.ActivityMonitor;
import Toybox.UserProfile;
import Toybox.Sensor;

class fr255_aly_watchfaceView extends WatchUi.WatchFace {
  hidden var img as Array<WatchUi.BitmapResource> = new Array<WatchUi.BitmapResource>[6];

  function initialize() { WatchFace.initialize(); }

  /* load your resources here, only load once */
  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));

    /* for x-mas */
    img[0] = WatchUi.loadResource(Rez.Drawables.authorIcon1);

    /* for normal day */
    img[1] = WatchUi.loadResource(Rez.Drawables.authorIcon2);
    img[2] = WatchUi.loadResource(Rez.Drawables.authorIcon3);
    img[3] = WatchUi.loadResource(Rez.Drawables.authorIcon4);
    img[4] = WatchUi.loadResource(Rez.Drawables.authorIcon5);
    img[5] = WatchUi.loadResource(Rez.Drawables.authorIcon6);
  }

  function onUpdate(dc as Dc) as Void {
    showDateTime();
    var batteryPer = showBattery();
    showActivityData();
    showHeartRate();
    showAuthorStr();

    View.onUpdate(dc);

    // draw your own custom from here
    var myAly = new Rez.Drawables.Aly();
    myAly.draw(dc);

    /* update progress bars */
    drawBattery(260, 50, 43, 25, 4, batteryPer, dc);
    drawBackgroundBasedOnMoment(dc, img);
  }

  function onShow() as Void {}
  function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be
  // started here.
  function onExitSleep() as Void {}

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() as Void {}

 private
  function showActivityData() as Void {
    var info = ActivityMonitor.getInfo();

    var mDistanceView = View.findDrawableById("DistanceDisplay") as Text;
    var mStepView = View.findDrawableById("StepDisplay") as Text;
    var mCalView = View.findDrawableById("CalDisplay") as Text;
    var mActiveMinView = View.findDrawableById("ActiveMinDisplay") as Text;

    mDistanceView.setText(Lang.format(
        "$1$ km",
        [(info.distance.toFloat() / 100.0 / 1000.0).format("%.02f")]));
    mStepView.setText(info.steps.toString());
    mCalView.setText(info.calories.toString());
    mActiveMinView.setText(info.activeMinutesDay.total.toString() + " mins");
  }

 private
  function showHeartRate() as Void {
    var mHeartRateIter = ActivityMonitor.getHeartRateHistory(1, true);
    var mCurHeartRate = mHeartRateIter.next().heartRate;
    var mHeartRateView = View.findDrawableById("HeartRateDisplay") as Text;

    if (mCurHeartRate == ActivityMonitor.INVALID_HR_SAMPLE) {
      mHeartRateView.setText("-- bpm");
    } else {
      mHeartRateView.setText(mCurHeartRate.format("%d") + " bpm");
    }
  }

 private
  function drawBattery(x, y, w, h, radius, percentage, dc as Dc) as Void {
    var mBatteryBar = new BatteryBar({
      :locX => x,
      :locY => y,
      :width => w,
      :height => h,
      :radius => radius
    });

    mBatteryBar.setPercent(percentage);
    mBatteryBar.draw(dc);
  }

 private
  function showBattery() as Float {
    var mSysStat = System.getSystemStats();

    var mBatteryDisplay = View.findDrawableById("BatteryDisplay") as Text;
    mBatteryDisplay.setText(mSysStat.battery.format("%d") + "%");

    return (mSysStat.battery / 100);
  }

 private
  function drawBackgroundBasedOnMoment(dc as Dc, imgArr as Array<WatchUi.BitmapResource>) as Void {
    var mDate = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);

    // dc.drawRectangle(0, 0.33 * dc.getHeight(), 170, 170);
    /* all images is 170x170 pixels */
    if (mDate.day >= 20 && mDate.day <= 25 && mDate.month == 12) {
      dc.drawBitmap(0, 0.33 * dc.getHeight(), imgArr[0]);
    } else {
      dc.drawBitmap(0, 0.33 * dc.getHeight(), imgArr[mDate.day % 5 + 1]);
    }
  }

 private
  function showDateTime() as Void {
    var mDate = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
    var mTime = System.getClockTime();

    var mDateView = View.findDrawableById("DateDisplay") as Text;
    mDateView.setText(Lang.format(
        "$1$, $2$ $3$", [ mDate.day_of_week, mDate.day, mDate.month ]));

    var mTimeView = View.findDrawableById("TimeDisplay") as Text;
    mTimeView.setText(Lang.format(
        "$1$:$2$", [ mTime.hour.format("%02d"), mTime.min.format("%02d") ]));
  }

 private
  function showAuthorStr() as Void {
    var mBeginLoveDay = {
      :year => 2021,
      :month => 12,
      :day => 20,
      :hour => 0,
      :minute => 1
    };

    var mBeginMoment = Time.Gregorian.moment(mBeginLoveDay);
    var mCurrentMoment = new Time.Moment(Time.today().value());
    var mLoveDaysView = View.findDrawableById("LoveDaysDisplay") as Text;
    mLoveDaysView.setText(
        Lang.format("$1$ days", [mCurrentMoment.subtract(mBeginMoment).value() /
                                    Gregorian.SECONDS_PER_DAY]));
  }
}
