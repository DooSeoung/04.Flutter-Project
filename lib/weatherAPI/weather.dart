import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class weatherAPI extends StatefulWidget {
  const weatherAPI({Key? key}) : super(key: key);

  @override
  _weatherAPI createState() => _weatherAPI();
}

class _weatherAPI extends State<weatherAPI> {

  // =================== 날씨 ===================
  String key = 'aa270e70b144fbfd66e090937a3864af'; //  My API Key
  double? lat;
  double? lon;
  late WeatherFactory wf;
  List<Weather> _data = List.empty(growable: true); // *************** Error : No element(Bad state) 으헝헝
  AppState _state = AppState.NOT_DOWNLOADED;

  @override
  void initState() {
    super.initState();
    wf = new WeatherFactory(key, language: Language.KOREAN);
    querytWeather();
  }

  void querytWeather() async{ // 날씨 나타내기

    // ============== 현재 위치의 위도 / 경도 가져오기 ===========
    // (emulator 사용하면 국가는 US로 나온다.)
    // --> AndroidManifest.xml (android/app/src/main) : permission 추가
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    this.lat = position.latitude;
    this.lon = position.longitude;

    setState(() {
      _state = AppState.DOWNLOADING;
    });

    print("lat: ${lat} ");
    print("lon: ${lon} ");
    Weather weather = await wf.currentWeatherByLocation(lat!, lon!);
    setState(() {
      _data = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget getTemperature(){ // 경도/위도 따른 날씨 출력
    if(_data.isNotEmpty){
      return Text(
        /*'나라 : ${_data[0].country}\n'
            '지역 : ${_data[0].areaName}\n'
            '날짜 : '
            '${_data[0].date.toString().substring(0,4)}년 '
            '${_data[0].date.toString().substring(5,7)}월 '
            '${_data[0].date.toString().substring(8,10)}일\n'
            '시간 : ${_data[0].date.toString().substring(11,16)}\n'
            '온도 : ${_data[0].temperature.toString().substring(0,4)}\n'
            '체감온도 : ${_data[0].tempFeelsLike.toString().substring(0,4)}도\n'
            '날씨 : ${_data[0].weatherMain}\n'*/
          '${_data[0].temperature.toString().substring(0,4)}'
      );
    }
    return Text(
        "[위치 정보를 불러오는 데 실패했습니다.]"
    );
  }

  Widget getDescription(){ // 경도/위도 따른 날씨 출력
    if(_data.isNotEmpty){
      return Text(
          '${_data[0].weatherDescription}'
      );
    }
    return Text(
        ""
    );
  }

  IconData weatherIcon(){ // change icon on weather condition
    IconData currentIcon = WeatherIcons.na;
    for(int i=0; i<_data.length; i++){
      if(_data.first.weatherMain.toString().contains('Clear')){
        currentIcon = WeatherIcons.day_sunny;
      }else if(_data.first.weatherMain.toString().contains('Rain')) {
        currentIcon = WeatherIcons.rain;
      }else if(_data.first.weatherMain.toString().contains('Cloud')){
        currentIcon = WeatherIcons.cloudy;
      }else if(_data.first.weatherMain.toString().contains('Wind')){
        currentIcon = WeatherIcons.windy;
      }else if(_data.first.weatherMain.toString().contains('Snow')){
        currentIcon = WeatherIcons.snow;
      }else if(_data.first.weatherMain.toString().contains('fog')){
        currentIcon = WeatherIcons.fog;
      }
    }
    return currentIcon;
  }

  String weatherBack(){ // change background img on weather condition
    String backImg = 'images/rainbow.png';
    for(int i=0; i<_data.length; i++){
      if(_data.first.weatherMain.toString().contains('Clear')){
        backImg = 'images/sunny.png';
      }else if(_data.first.weatherMain.toString().contains('Rain')) {
        backImg = 'images/rain.jpg';
      }else if(_data.first.weatherMain.toString().contains('Cloud')){
        backImg = 'images/cloud.jpg';
      }else if(_data.first.weatherMain.toString().contains('Wind')){
        backImg = 'images/windy.jpg';
      }else if(_data.first.weatherMain.toString().contains('Snow')){
        backImg = 'images/snow.jpg';
      }else if(_data.first.weatherMain.toString().contains('fog')){
        backImg = 'images/fog.jpg';
      }
    }
    return backImg;
  }

  @override
  Widget build(BuildContext context) {
    return Padding( //****************************************************날씨
        padding: EdgeInsets.all(20),
        child: Container( // 배경 색을 위해 Container 감싸기
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
            children: <Widget>[
              getTemperature(), // 날씨 상태 표시
              Icon(WeatherIcons.celsius),
              getDescription(),
              // Image.asset('images/sunny.png', fit: BoxFit.cover),
              Icon(
                  weatherIcon() // 날씨에 따른 아이콘 표시
              )
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(weatherBack()),
                  fit: BoxFit.cover
              )
          ),
          //color: Colors.lightGreen,
        )
      // Text('${_selectedDay.toString().substring(0,10)}'),
    );
  }
}
