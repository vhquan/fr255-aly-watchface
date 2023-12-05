import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class fr255_aly_watchfaceView extends WatchUi.WatchFace {
  function initialize() { WatchFace.initialize(); }

  function onLayout(dc as Dc) as Void { setLayout(Rez.Layouts.WatchFace(dc)); }

  function onUpdate(dc as Dc) as Void {
    showTime();
    showDate();
    var batteryDisplay = showBattery();
    showAuthor();
    showLoveDays();

    View.onUpdate(dc);

    // draw object from drawable-list
    var myAly = new Rez.Drawables.Aly();
    myAly.draw(dc);

    drawBattery(50, 190, 60, 5, 65348, batteryDisplay / 100, dc);
  }

  function onShow() as Void {}
  function onHide() as Void {}
  function onExitSleep() as Void {}
  function onEnterSleep() as Void {}

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
    mHourView.setText(Lang.format("$1$", [mTime.hour]));

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
