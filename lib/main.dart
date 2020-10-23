import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherappbocpattern/WeatherBloc.dart';
import 'package:weatherappbocpattern/WeatherModel.dart';
import 'package:weatherappbocpattern/WeatherRepo.dart';
//import 'package:weatherappbocpattern/WeatherModel.dart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: BlocProvider(
          builder: (context) => WeatherBloc(WeatherRepo()),
          child: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    final weatherBloc= BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<WeatherBloc,WeatherState>(
              builder: (context,WeatherState state){
                if(state is WeatherIsNotSearched){

                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: cityController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Search Weather"
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        RaisedButton(
                          child: Center(child: Text("Click ME"),),
                          onPressed: (){
                            weatherBloc.add(FetchWeather(cityController.text.toString()));
                          },
                        )
                      ],
                    )
                  );

                }else if(state is WeatherIsLoading){
                  return Center(child: CircularProgressIndicator(),);

                }else if (state is WeatherIsLoaded){
                  return ShowWeather(state.getWeather, cityController.text.toString());
                  
                }else{
                  return Text("Error",style: TextStyle(color: Colors.white),);
                }

              },
            )

          ],
        ),
      ),

    );
  }
}



class ShowWeather extends StatelessWidget {
  WeatherModel weather;
  final city;

  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 32, left: 32, top: 10),
        child: Column(
          children: <Widget>[
            Text(city,style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),

            Text(weather.getTemp.round().toString()+"C",style: TextStyle(color: Colors.black, fontSize: 50),),
            Text("Temprature",style: TextStyle(color: Colors.black, fontSize: 14),),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(weather.getMinTemp.round().toString()+"C",style: TextStyle(color: Colors.black, fontSize: 30),),
                    Text("Min Temprature",style: TextStyle(color: Colors.black, fontSize: 14),),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(weather.getMaxTemp.round().toString()+"C",style: TextStyle(color: Colors.black, fontSize: 30),),
                    Text("Max Temprature",style: TextStyle(color: Colors.black, fontSize: 14),),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: (){
                  BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                },
                color: Colors.lightBlue,
                child: Text("Search", style: TextStyle(color: Colors.white70, fontSize: 16),),

              ),
            )
          ],
        )
    );
  }
}
