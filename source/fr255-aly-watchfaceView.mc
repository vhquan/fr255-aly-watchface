import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.ActivityMonitor;
import Toybox.UserProfile;
import Toybox.Sensor;

class fr255_aly_watchfaceView extends WatchUi.WatchFace {
 private
  var xmas, normal;

  function initialize() {
    WatchFace.initialize();
    xmas = WatchUi.loadResource(Rez.Drawables.authorIcon1);
    normal = WatchUi.loadResource(Rez.Drawables.authorIcon2);
  }

  function onLayout(dc as Dc) as Void { setLayout(Rez.Layouts.WatchFace(dc)); }

  function onUpdate(dc as Dc) as Void {
    showDateTime();
    var batteryPer = showBattery();
    showActivityData();
    showHeartRate();
    showAuthorStr();

    View.onUpdate(dc);

    // draw object from drawable-list
    var myAly = new Rez.Drawables.Aly();
    myAly.draw(dc);

    /* update progress bars */
    drawBattery(180, 20, 35, 20, 4, batteryPer, dc);
    drawBackgroundBasedOnMoment(dc, xmas, normal);
  }

  function onShow() as Void {}
  function onHide() as Void {}
  function onExitSleep() as Void {}
  function onEnterSleep() as Void {}

 private
  function showActivityData() as Void {
    var info = ActivityMonitor.getInfo();

    var mDistanceView = View.findDrawableById("DistanceDisplay") as Text;
    var mStepView = View.findDrawableById("StepDisplay") as Text;
    var mRespirationRateView =
        View.findDrawableById("RespirationRateDisplay") as Text;
    var mCalView = View.findDrawableById("CalDisplay") as Text;
    var mActiveMinView = View.findDrawableById("ActiveMinDisplay") as Text;

    mDistanceView.setText(Lang.format(
        "$1$ km",
        [(info.distance.toFloat() / 100.0 / 1000.0).format("%.02f")]));
    mStepView.setText(info.steps.toString());
    mRespirationRateView.setText(info.respirationRate.toString() + " br/m");
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
  function drawBackgroundBasedOnMoment(dc as Dc, xmas, normal) as Void {
    var mDate = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);

    if (mDate.day >= 20 && mDate.day <= 25 && mDate.month == 12) {
      dc.drawBitmap(0, 0.3 * dc.getHeight(), xmas);
    } else {
      dc.drawBitmap(0, 0.3 * dc.getHeight(), normal);
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

    var authorView = View.findDrawableById("AuthorDisplay") as Text;
    authorView.setText(Rez.Strings.AuthorWannaSay);
  }
}
