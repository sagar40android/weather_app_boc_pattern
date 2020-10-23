import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weatherappbocpattern/WeatherModel.dart';

class WeatherRepo{

  Future<WeatherModel> getWeather(String city) async{
    final response = await http.get("http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=cf4b76b0b03595aa6f424c92f4757e53");

    if(response.statusCode == 200){
      var jsonResponseResult =json.decode(response.body);

      return WeatherModel.fromJson(jsonResponseResult["main"]);
    }else{
      throw Exception();
    }

  }
}