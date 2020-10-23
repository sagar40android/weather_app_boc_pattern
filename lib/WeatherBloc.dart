
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:weatherappbocpattern/WeatherRepo.dart';
import 'WeatherModel.dart';
//////// Event
class WeatherEvent extends Equatable{
  @override
  List<Object> get props => [];

}

class FetchWeather extends WeatherEvent{
  String city;

  FetchWeather(this.city);

  @override
  List<Object> get props {
    return [city];
  }

}

class ResetWeather extends WeatherEvent{

}


/////// State

class WeatherState extends Equatable{
  @override
  List<Object> get props => [];

}

class WeatherIsNotSearched  extends WeatherState{

}

class WeatherIsLoading  extends WeatherState{

}

class WeatherIsLoaded extends WeatherState{
  final _weather;

  WeatherIsLoaded(this._weather);

  WeatherModel get getWeather  => _weather;
@override
  List<Object> get props => [_weather];
}

class WeatherIsNotLoaded  extends WeatherState{

}


//////////////   Bloc

class WeatherBloc extends Bloc<WeatherEvent,WeatherState>{
  WeatherRepo weatherRepo;


  WeatherBloc(this.weatherRepo);

  @override
  WeatherState get initialState =>WeatherIsNotSearched();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async*{
    // T
   if (event is FetchWeather){
     yield WeatherIsLoading();
     
     try {
       WeatherModel weatherModel   = await weatherRepo.getWeather(event.city);
       yield WeatherIsLoaded(weatherModel);
     } on Exception catch (e) {
      yield WeatherIsNotLoaded();
     }

   }else if (event is ResetWeather){
     yield WeatherIsNotSearched();
   }
  }

}

