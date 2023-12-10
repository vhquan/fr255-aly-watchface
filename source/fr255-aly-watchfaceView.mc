import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.ActivityMonitor;
import Toybox.UserProfile;
import Toybox.Sensor;

class fr255_aly_watchfaceView extends WatchUi.WatchFace {
  function initialize() { WatchFace.initialize(); }

  function onLayout(dc as Dc) as Void { setLayout(Rez.Layouts.WatchFace(dc)); }

  function onUpdate(dc as Dc) as Void {
    showTime();
    showDate();
    showBattery();
    showHeartRate();
    showActivityData();

    View.onUpdate(dc);
  }

  function onShow() as Void {}
  function onHide() as Void {}
  function onExitSleep() as Void {}
  function onEnterSleep() as Void {}

 private
  function showActivityData() as Void {
    var info = ActivityMonitor.getInfo();

    var mStepView = View.findDrawableById("StepDisplay") as Text;
    var mCalView = View.findDrawableById("CalDisplay") as Text;
    var climbView = View.findDrawableById("FloorDisplay") as Text;
    var mDistanceView = View.findDrawableById("DistanceDisplay") as Text;

    mCalView.setText(info.calories.toString());
    mStepView.setText(info.steps.toString());
    climbView.setText(Lang.format(
        "$1$/$2$",
        [ info.floorsClimbed.toString(), info.floorsDescended.toString() ]));
    mDistanceView.setText(Lang.format(
        "$1$ km",
        [(info.distance.toFloat() / 100.0 / 1000.0).format("%.02f")]));
  }

 private
  function showHeartRate() as Void {
    var mHeartRateIter = ActivityMonitor.getHeartRateHistory(1, true);
    var mCurHeartRate = mHeartRateIter.next().heartRate;
    var mHeartRateView = View.findDrawableById("HeartRateDisplay") as Text;

    if (mCurHeartRate == ActivityMonitor.INVALID_HR_SAMPLE) {
      mHeartRateView.setText("-- bpm");
    } else {
      mHeartRateView.setText(mCurHeartRate.toString() + " bpm");
    }
  }

 private
  function showBattery() as Void {
    var mSysStat = System.getSystemStats();

    var mBatteryDisplay = View.findDrawableById("BatteryDisplay") as Text;
    mBatteryDisplay.setText(mSysStat.battery.format("%d") + "%");
  }

 private
  function showTime() as Void {
    var mTime = System.getClockTime();
    var devSetting = System.getDeviceSettings();

    var mTimeView = View.findDrawableById("TimeDisplay") as Text;
    var mFormatTimeView = View.findDrawableById("TimeFormatDisplay") as Text;

    if (devSetting.is24Hour == true) {
      mTimeView.setText(Lang.format(
          "$1$:$2$", [ mTime.hour.format("%02d"), mTime.min.format("%02d") ]));
      mFormatTimeView.setText("[24H]");
    } else {
      if (mTime.hour > 12) {
        mFormatTimeView.setText("[PM]");
      } else {
        mFormatTimeView.setText("[AM]");
      }

      mTimeView.setText(Lang.format(
          "$1$:$2$",
          [ (mTime.hour - 12).format("%02d"), mTime.min.format("%02d") ]));
    }
  }

 private
  function showDate() as Void {
    var mDate = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);

    var mDateView = View.findDrawableById("DateDisplay") as Text;
    mDateView.setText(Lang.format(
        "$1$ $2$ $3$", [ mDate.day_of_week, mDate.month, mDate.day ]));
  }
}
