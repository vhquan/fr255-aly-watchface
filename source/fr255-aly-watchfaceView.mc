import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.ActivityMonitor;
import Toybox.UserProfile;

class fr255_aly_watchfaceView extends WatchUi.WatchFace {
  function initialize() { WatchFace.initialize(); }

  function onLayout(dc as Dc) as Void { setLayout(Rez.Layouts.WatchFace(dc)); }

  function onUpdate(dc as Dc) as Void {
    showTime();
    showDate();
    var batteryDisplay = showBattery();
    var stepDisplay = showSteps();
    showHeartRate();
    var activeCal = showActiveCalories();
    showDistance();

    showAuthor();
    showLoveDays();

    View.onUpdate(dc);

    // draw object from drawable-list
    var myAly = new Rez.Drawables.Aly();
    myAly.draw(dc);

    drawBattery(50, 195, 70, 5, 65348, batteryDisplay / 100, dc);
    drawStep(57, 216, 63, 5, 58364, stepDisplay, dc);
    // offset 1 pixel for x to overdrawn the void space
    drawCal(140, 195, 71, 5, 16735488, activeCal, dc);
  }

  function onShow() as Void {}
  function onHide() as Void {}
  function onExitSleep() as Void {}
  function onEnterSleep() as Void {}

 private
  function showDistance() as Void {
    var info = ActivityMonitor.getInfo();
    var mDistanceView = View.findDrawableById("DistanceDisplay") as Text;
    mDistanceView.setText(
        Lang.format("$1$ km", [((info.distance / 100) / 1000).format("%d")]));
  }

 private
  function drawCal(x, y, w, h, color, percentage, dc as Dc) as Void {
    var mCalBar = new InverseHorizontalProgressBar({
      :locX => x,
      :locY => y,
      :width => w,
      :height => h,
      :color => color
    });

    mCalBar.setPercent(percentage);
    mCalBar.draw(dc);
  }

 private
  function showActiveCalories() as Float {
    var mDate = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var mRMR = 0;
    var mProfile = null;
    var mRestingCal = 0;
    var mActive = null;
    var mResting = null;
    var info = ActivityMonitor.getInfo();

    // RMR function source Harris-Benedict
    mProfile = UserProfile.getProfile();
    if (mProfile.gender == UserProfile.GENDER_FEMALE) {
      mRMR = 655 + (9.5 * mProfile.weight / 1000) + (1.9 * mProfile.height) +
             (4.7 * (mDate.year - mProfile.birthYear));
    }
    if (mProfile.gender == UserProfile.GENDER_MALE) {
      mRMR = 66 + (13.7 * mProfile.weight / 1000) + (5 * mProfile.height) -
             (6.8 * (mDate.year - mProfile.birthYear));
    }

    mRestingCal = (info.activeMinutesDay.total) * mRMR / (24 * 60);

    mActive = View.findDrawableById("ActiveCalDisplay") as Text;
    mActive.setText((info.calories - mRestingCal).format("%d"));

    mResting = View.findDrawableById("RestingCalDisplay") as Text;
    mResting.setText(mRestingCal.format("%d"));

    if (info.calories == 0) {
      return 0.0;
    }

    return (1 - mRestingCal / info.calories);
  }

 private
  function showHeartRate() as Void {
    var mHeartRateIter = ActivityMonitor.getHeartRateHistory(null, false);
    var mCurHeartRate = mHeartRateIter.next().heartRate;
    var mHeartRateView = View.findDrawableById("HeartRateDisplay") as Text;

    if (mCurHeartRate == ActivityMonitor.INVALID_HR_SAMPLE) {
      mHeartRateView.setText("NaN");
    } else {
      mHeartRateView.setText(mCurHeartRate.format("%d"));
    }
  }

 private
  function drawStep(x, y, w, h, color, percentage, dc as Dc) as Void {
    var mStepBar = new HorizontalProgressBar({
      :locX => x,
      :locY => y,
      :width => w,
      :height => h,
      :color => color
    });

    mStepBar.setPercent(percentage);
    mStepBar.draw(dc);
  }

 private
  function drawBattery(x, y, w, h, color, percentage, dc as Dc) as Void {
    var mBatteryBar = new HorizontalProgressBar({
      :locX => x,
      :locY => y,
      :width => w,
      :height => h,
      :color => color
    });

    mBatteryBar.setPercent(percentage);
    mBatteryBar.draw(dc);
  }

 private
  function showSteps() as Float {
    var mStep = ActivityMonitor.getInfo().steps.toString();
    var stepGoalPercent = ((ActivityMonitor.getInfo().steps).toFloat() /
                           (ActivityMonitor.getInfo().stepGoal).toFloat());

    var mStepView = View.findDrawableById("StepDisplay") as Text;
    mStepView.setText(mStep);

    return stepGoalPercent;
  }

 private
  function showBattery() as Lang.Float {
    var mBattery = System.getSystemStats().battery;

    var mBatteryDisplay = View.findDrawableById("BatteryDisplay") as Text;
    mBatteryDisplay.setText(mBattery.format("%d") + "%");
    return mBattery;
  }

 private
  function showTime() as Void {
    var mTime = System.getClockTime();

    var mHourView = View.findDrawableById("HourDisplay") as Text;
    mHourView.setText(Lang.format("$1$", [mTime.hour.format("%02d")]));

    var mMinView = View.findDrawableById("MinDisplay") as Text;
    mMinView.setText(Lang.format("$1$", [mTime.min.format("%02d")]));
  }

 private
  function showDate() as Void {
    var mDate = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);

    var mDayView = View.findDrawableById("DayDisplay") as Text;
    mDayView.setText(Lang.format("$1$", [mDate.day]));

    var mMonthView = View.findDrawableById("MonthDisplay") as Text;
    mMonthView.setText(Lang.format("$1$", [mDate.month]));

    var mDayOfWeekView = View.findDrawableById("DayOfWeekDisplay") as Text;
    mDayOfWeekView.setText(Lang.format("$1$", [mDate.day_of_week]));
  }

 private
  function showLoveDays() as Void {
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
    mLoveDaysView.setText(Lang.format(
        "$1$ days since", [mCurrentMoment.subtract(mBeginMoment).value() /
                              Gregorian.SECONDS_PER_DAY]));
  }

 private
  function showAuthor() as Void {
    var authorView = View.findDrawableById("AuthorDisplay") as Text;
    authorView.setText("By Aly's Quan");
  }
}
