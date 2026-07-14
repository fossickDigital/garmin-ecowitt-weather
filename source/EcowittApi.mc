using Toybox.Application;
using Toybox.Communications;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;

var weather = new WeatherData();

class EcowittApi {

    function degreesToCompass(degrees) {
        var dirs = [
            "N", "NNE", "NE", "ENE",
            "E", "ESE", "SE", "SSE",
            "S", "SSW", "SW", "WSW",
            "W", "WNW", "NW", "NNW"
        ];

        var deg = degrees.toNumber();
        var index = ((deg + 11) / 22).toNumber() % 16;

        return dirs[index];
    }

    function fahrenheitToC(temp) {
        return (((temp.toNumber() - 32.0) * 5.0) / 9.0).format("%.1f");
    }

    function mphToKnots(speed) {
        return (speed.toNumber() * 0.868976).format("%.1f");
    }

    function inHgTohPa(pressure) {
        return (pressure.toNumber() * 33.8639).format("%.1f");
    }

    function load() as Void {
        var app = Application.getApp();

        var applicationKey = app.getProperty("applicationKey");
        var apiKey = app.getProperty("apiKey");
        var stationMac = app.getProperty("stationMac");

        if (
            applicationKey == null ||
            apiKey == null ||
            stationMac == null ||
            applicationKey.toString().length() == 0 ||
            apiKey.toString().length() == 0 ||
            stationMac.toString().length() == 0
        ) {
            System.println("Ecowitt settings not configured.");
            return;
        }

        var url =
            "https://api.ecowitt.net/api/v3/device/real_time"
            + "?application_key=" + applicationKey
            + "&api_key=" + apiKey
            + "&mac=" + stationMac
            + "&call_back=all";

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {},
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Communications.makeWebRequest(
            url,
            null,
            options,
            method(:onResponse)
        );
    }

    function onResponse(
        responseCode as Lang.Number,
        data as Lang.Dictionary or Lang.String or Null
    ) as Void {

        System.println("HTTP: " + responseCode);

        if (responseCode != 200 || data == null) {
            System.println("Ecowitt request failed.");
            return;
        }

        var responseData = data["data"];
        var wind = responseData["wind"];
        var outdoor = responseData["outdoor"];
        var indoor = responseData["indoor"];
        var pressure = responseData["pressure"];

        var windDegrees = wind["wind_direction"]["value"];
        var windDir = degreesToCompass(windDegrees);

        var windSpeed = mphToKnots(wind["wind_speed"]["value"]);
        var gust = mphToKnots(wind["wind_gust"]["value"]);

        var outTemp = fahrenheitToC(outdoor["temperature"]["value"]);
        var inTemp = fahrenheitToC(indoor["temperature"]["value"]);

        var pressureHpa = inHgTohPa(
            pressure["relative"]["value"]
        );

        weather.windDir = windDir;
        weather.windDegrees = windDegrees;
        weather.windSpeed = windSpeed;
        weather.gust = gust;
        weather.outTemp = outTemp;
        weather.inTemp = inTemp;
        weather.pressure = pressureHpa;
        weather.pressureTrend = "=";

        WatchUi.requestUpdate();
        System.println("Updated weather model");
    }
}