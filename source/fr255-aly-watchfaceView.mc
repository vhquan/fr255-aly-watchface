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
    showAuthor();

    View.onUpdate(dc);

    var myAly = new Rez.Drawables.Aly();
    myAly.draw(dc);
  }

  function onShow() as Void {}
  function onHide() as Void {}
  function onExitSleep() as Void {}
  function onEnterSleep() as Void {}

 private
  function showTime() {
    var mTime = System.getClockTime();

    var mHourView = View.findDrawableById("HourDisplay") as Text;
    mHourView.setText(Lang.format("$1$", [mTime.hour]));

    var mMinView = View.findDrawableById("MinDisplay") as Text;
    mMinView.setText(Lang.format("$1$", [mTime.min.format("%02d")]));
  }

 private
  function showDate() {
    var mDate = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);

    var mDayView = View.findDrawableById("DayDisplay") as Text;
    mDayView.setText(Lang.format("$1$", [mDate.day]));

    var mMonthView = View.findDrawableById("MonthDisplay") as Text;
    mMonthView.setText(Lang.format("$1$", [mDate.month]));

    var mDayOfWeekView = View.findDrawableById("DayOfWeekDisplay") as Text;
    mDayOfWeekView.setText(Lang.format("$1$", [mDate.day_of_week]));
  }

 private
  function showAuthor() {
    var authorView = View.findDrawableById("AuthorDisplay") as Text;
    authorView.setText("By Aly's Quan");
  }
}
