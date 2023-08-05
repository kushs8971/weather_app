import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:action_slider/action_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _cityController = TextEditingController();
  String datetime = '';
  String? datetime3;
  String? datetime2;
  String? imageUrl;
  String? temperature = "";
  String? date = "";
  String? time = "";
  String? conditionText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              _buildCityInput(),
              SizedBox(height: 20,),
              _buildActionSlider(),
              SizedBox(height: 20,),
              _buildCityName(),
              SizedBox(height: 20,),
              _buildCityImage(),
              SizedBox(height: 20,),
              _buildCityInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 20),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 40,
                width: 40,
              ),
              SizedBox(width: 10),
              Text(
                "Weather App",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'SF Compact',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }

  Widget _buildCityInput() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        onChanged: (value) {
          _cityController.text = value.toUpperCase();
          _cityController.selection = TextSelection.fromPosition(
            TextPosition(offset: _cityController.text.length),
          ); // Maintain cursor position
        },
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'SF Compact',
          fontWeight: FontWeight.bold,
        ),
        controller: _cityController,
        decoration: InputDecoration(
            labelText: "CITY NAME",
            labelStyle: TextStyle(
                fontFamily: 'SF Compact',
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
            )
        ),
      ),
    );
  }

  Widget _buildActionSlider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ActionSlider.standard(
        sliderBehavior: SliderBehavior.stretch,
        rolling: true,
        width: double.maxFinite,
        child: const Text(
          'SLIDE ME',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'SF Compact',
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        toggleColor: Colors.lightBlueAccent,
        iconAlignment: Alignment.centerRight,
        loadingIcon: SizedBox(
          width: 55,
          child: Center(
            child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                  strokeWidth: 2.0, color: Colors.limeAccent),
            ),
          ),
        ),
        successIcon: const SizedBox(
          width: 55,
          child: Center(
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
            ),
          ),
        ),
        icon: const SizedBox(
          width: 55,
          child: Center(
            child: Icon(
              Icons.refresh_rounded,
              color: Colors.white,
            ),
          ),
        ),
        action: (controller) async {
          controller.loading();
          if (_cityController.text.isEmpty) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "NOTHING FOUND",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF Compact',
                    fontSize: 20,
                  ),
                ),
                content: Text(
                  'ENTER CITY NAME',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'SF Compact',
                    fontSize: 14,
                  ),
                ),
              ),
            );
            await Future.delayed(Duration(seconds: 3)).then((_) {
              Navigator.pop(context);
            });
          } else {
            setState(() {
              imageUrl =
              'https://source.unsplash.com/800x600/?${_cityController.text}';
            });
            fetchTemperature(_cityController.text);
          }
          controller.reset();
        },
      ),
    );

  }

  Widget _buildCityName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/map.png",
          height: 40,
          width: 40,
        ),
        SizedBox(width: 10),
        Text(
          _cityController.text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'SF Compact',
            fontSize: 24,
          ),
        ),
      ],
    );

  }

  Widget _buildCityImage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.maxFinite,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: imageUrl != null
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
        )
            : Container(
          child: Center(
            child: Text(
              "COULDN'T FIND YOUR IMAGE",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'SF Compact',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );

  }

  Widget _buildCityInfo() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xff74D3FF),
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.thermostat,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Temperature - ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Compact',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    temperature.toString() + " °",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Compact',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Text(
                  "Current Date",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'SF Compact',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Image.asset(
                  "assets/images/calendar.png",
                  height: 20,
                  width: 20,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Current Time",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'SF Compact',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Image.asset(
                  "assets/images/clock.png",
                  height: 20,
                  width: 20,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Text(
                datetime.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'SF Compact',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                time.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'SF Compact',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          height: 110,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 2,
              )
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "CONDITION",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'SF Compact',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_cityController.text.isEmpty)
                Image.asset(
                  'assets/images/shrug.png',
                  height: 60,
                  width: 60,
                )
              else if (conditionText != null)
                getWeatherConditionImageUrl(conditionText!)
              else
                Container(
                  child: Text(conditionText.toString()),
                ),
            ],
          ),
        )
      ],
    );
  }

  Widget getWeatherConditionImageUrl(String? conditionText) {
    if (_cityController.text.isEmpty || conditionText == null) {
      return Image.asset('assets/images/shrug.png');
    }
    switch (conditionText.toLowerCase()) {
      case 'sunny':
        return Image.asset('assets/images/sun.png',height: 60,width: 60,);
      case 'rainy':
        return Image.asset('assets/images/rain.png',height: 60,width: 60,);
      case 'snowy':
        return Image.asset('assets/images/snowman.png',height: 60,width: 60,);
      case 'cloudy':
        return Image.asset('assets/images/clouds.png',height: 60,width: 60,);
      case 'light rain':
        return Image.asset('assets/images/rain.png',height: 60,width: 60,);
      default:
        return Text(conditionText.toUpperCase(),
          style: TextStyle(
              color: Colors.yellow,
              fontFamily: 'SF Compact',
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        );
    }
  }

  Future<void> fetchTemperature(String location) async {
    final apiKey = "233113c3f5ce4ad7b71122511231207";
    final url = Uri.parse(
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final temperature = jsonData['current']['temp_c'].toString();
      var dateTimeLocal = jsonData['location']['localtime'] as String;
      var conditionText = jsonData['current']['condition']['text'] as String;
      DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(dateTimeLocal);
      String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(parsedDate);
      setState(() {
        this.temperature = temperature;
        this.datetime = formattedDate;
        DateTime parsedTime =
        DateFormat("HH:mm").parse(dateTimeLocal.split(' ')[1]);
        this.time = DateFormat.jm().format(parsedTime);
        this.conditionText = conditionText;
        print(conditionText);
      });
    } else {
      throw Exception('Failed to fetch temperature for $location');
    }
  }

}

