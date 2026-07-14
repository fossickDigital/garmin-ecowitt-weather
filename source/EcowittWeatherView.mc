using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.System;


class EcowittWeatherView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
  function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
   function onShow() as Void {
    System.println("Widget shown");
    var api = new EcowittApi();
    api.load();
}

    // Update the view
function onUpdate(dc as Graphics.Dc) as Void {
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();

    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

    var w = dc.getWidth();
    var cx = w / 2;

    // vertical divider
    dc.drawLine(cx, 65, cx, 225);

   // LEFT: Wind
dc.drawText(35, 55, Graphics.FONT_SMALL, "WIND", Graphics.TEXT_JUSTIFY_LEFT);
dc.drawText(35, 85, Graphics.FONT_LARGE, weather.windDir, Graphics.TEXT_JUSTIFY_LEFT);
dc.drawText(35, 125, Graphics.FONT_SMALL, weather.windDegrees + "°", Graphics.TEXT_JUSTIFY_LEFT);
dc.drawText(35, 155, Graphics.FONT_MEDIUM, weather.windSpeed + " kt", Graphics.TEXT_JUSTIFY_LEFT);
dc.drawText(35, 185, Graphics.FONT_SMALL, "G " + weather.gust + " kt", Graphics.TEXT_JUSTIFY_LEFT);

// RIGHT: Temperature & Pressure
dc.drawText(cx + 15, 55, Graphics.FONT_SMALL, "TEMP", Graphics.TEXT_JUSTIFY_LEFT);

dc.drawText(cx + 15, 90, Graphics.FONT_SMALL, "O", Graphics.TEXT_JUSTIFY_LEFT);
dc.drawText(w - 20, 90, Graphics.FONT_MEDIUM, weather.outTemp + "°", Graphics.TEXT_JUSTIFY_RIGHT);

dc.drawText(cx + 15, 120, Graphics.FONT_SMALL, "I", Graphics.TEXT_JUSTIFY_LEFT);
dc.drawText(w - 20, 120, Graphics.FONT_MEDIUM, weather.inTemp + "°", Graphics.TEXT_JUSTIFY_RIGHT);

dc.drawText(cx + 15, 165, Graphics.FONT_SMALL, "PRES", Graphics.TEXT_JUSTIFY_LEFT);
dc.drawText(cx + 15, 190, Graphics.FONT_SMALL, weather.pressure, Graphics.TEXT_JUSTIFY_LEFT);
dc.drawText(w - 30, 190, Graphics.FONT_SMALL, "=", Graphics.TEXT_JUSTIFY_RIGHT);
}

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
