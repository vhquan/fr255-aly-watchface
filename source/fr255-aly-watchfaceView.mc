import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.ActivityMonitor;
import Toybox.UserProfile;

class fr255_aly_watchfaceView extends WatchUi.WatchFace {
 private
  var _animationDelegate;

  function initialize() {
    WatchFace.initialize();
    _animationDelegate = new beeDanceAnimationController();
  }

  function onLayout(dc as Dc) as Void { setLayout(Rez.Layouts.WatchFace(dc)); }

  function onUpdate(dc as Dc) as Void {
    showTime();
    showDate();
    showBattery();
    showSteps();
    showHeartRate();
    showActiveCalories();
    showDistance();
    showFloorUpDown();
    // showRespirationRate();

    showAuthor();
    showLoveDays();

    View.onUpdate(dc);

    // draw object from drawable-list
    var myAly = new Rez.Drawables.Aly();
    myAly.draw(dc);

    // drawBattery(50, 195, 70, 5, 65348, batteryDisplay / 100, dc);
    // drawStep(57, 216, 63, 5, 58364, stepDisplay, dc);
  }

  function onShow() as Void {
    _animationDelegate.handleOnShow(self);
    _animationDelegate.play();
  }
  function onHide() as Void { _animationDelegate.handleOnHide(self); }
  function onExitSleep() as Void { _animationDelegate.play(); }
  function onEnterSleep() as Void { _animationDelegate.stop(); }

 private
  function showDistance() as Void {
    var info = ActivityMonitor.getInfo();
    var mDistanceView = View.findDrawableById("DistanceDisplay") as Text;
    mDistanceView.setText(
        Lang.format("$1$ m", [(info.distance / 100).format("%d")]));
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
  function showRespirationRate() as Void {
    var info = ActivityMonitor.getInfo();

    var mRespirationRateView =
        View.findDrawableById("RespirationRateDisplay") as Text;
    mRespirationRateView.setText(info.respirationRate.toString());
  }

 private
  function showFloorUpDown() as Void {
    var info = ActivityMonitor.getInfo();

    var climbView = View.findDrawableById("ClimbFloorDisplay") as Text;
    var descendView = View.findDrawableById("DescendFloorDisplay") as Text;
    var targetView = View.findDrawableById("TargetFloorDisplay") as Text;

    climbView.setText(info.floorsClimbed.toString());
    targetView.setText(info.floorsClimbedGoal.toString());
    descendView.setText(info.floorsDescended.toString());
  }

 private
  function showActiveCalories() as Void {
    var info = ActivityMonitor.getInfo();
    var mCalView = View.findDrawableById("CalDisplay") as Text;
    var calories = info.calories * 1000;
    mCalView.setText(calories.toString() + " Cal");
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
  function showSteps() as Void {
    var mStep = ActivityMonitor.getInfo().steps.toString();

    var mStepView = View.findDrawableById("StepDisplay") as Text;
    mStepView.setText(mStep);
  }

 private
  function showBattery() as Void {
    var mSysStat = System.getSystemStats();
    var mBattery = mSysStat.battery;
    var mBatteryInDays = mSysStat.batteryInDays;

    var mBatteryDisplay = View.findDrawableById("BatteryDisplay") as Text;
    mBatteryDisplay.setText(mBattery.format("%d") + "%" + " (~ " +
                            mBatteryInDays.format("%d") + " d)");
  }

 private
  function showTime() as Void {
    var mTime = System.getClockTime();

    var mTimeView = View.findDrawableById("TimeDisplay") as Text;
    mTimeView.setText(Lang.format("$1$:$2$", [mTime.hour.format("%02d"), mTime.min.format("%02d")]));
  }

 private
  function showDate() as Void {
    var mDate = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);

    var mDateView = View.findDrawableById("DateDisplay") as Text;
    mDateView.setText(Lang.format("$1$, $2$ $3$ $4$", [mDate.day_of_week, mDate.day, mDate.month, mDate.year]));
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
    mLoveDaysView.setText(
        Lang.format("$1$ days", [mCurrentMoment.subtract(mBeginMoment).value() /
                                    Gregorian.SECONDS_PER_DAY]));
  }

 private
  function showAuthor() as Void {
    var authorView = View.findDrawableById("AuthorDisplay") as Text;
    authorView.setText("Aly's Quan");
  }
}
