import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cityName = TextEditingController();
  @override
  void dispose() {
    cityName.dispose();
    super.dispose();
  }

  var infos;
  var long;
  var lat;
  var temp;
  var humidity;
  var name;

  var cityNam;
  var longi;
  var lati;
  var tempt;
  var humidit;

  bool jsonstate = false;
  bool xmstate = false;
  getData(String cityname) async {
    String myUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=${cityname}&appid=86a15e450b8914503ebb7ada1a767ade&units=imperial";
    var req = await http.get(Uri.parse(myUrl));
    infos = json.decode(req.body);
    long = infos["coord"]['lon'];
    lat = infos["coord"]['lat'];
    temp = infos['main']['temp'];
    humidity = infos['main']['humidity'];
    name = infos['name'];
    return infos['name'];
  }

  getDataXML(String cityname) async {
    int len = cityname.length;
    String myUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=${cityname}&appid=86a15e450b8914503ebb7ada1a767ade&units=imperial&mode=xml";
    var reqxml = await http.get(Uri.parse(myUrl));
    // print(reqxml.body);
    final document = XmlDocument.parse(reqxml.body);
    //print(document.toXmlString(pretty: true, indent: '\t'));
    var city = document.findAllElements('city');
    city.map((node) => node.getAttribute('name')).toList();
    var list = city.toString();
    //
    //print(len);
    int temp = 26 + len;
    cityNam = list.substring(26, temp);
    //
    var lontemp = list.indexOf('lon');
    int lonind = lontemp;
    int somelon = lontemp + 5;
    int lonend = somelon + 5;
    longi = list.substring(somelon, lonend);
    var laTtemp = list.indexOf('lat');
    int somelatistart = laTtemp + 5;
    int somelatend = somelatistart + 5;
    lati = list.substring(somelatistart, somelatend);
    //
    var heat = document.findAllElements('temperature');
    var listheat = heat.toString();
    var heattemp = listheat.indexOf('value');
    tempt = listheat.substring(21, 26);
    //
    var temphumid = document.findAllElements('humidity');
    var humidstr = temphumid.toString();
    var humidind = humidstr.indexOf('value');
    humidit = humidstr.substring(18, 20);
    //
    print(humidity);
    // print(laTtemp);
    print(longi);
    print(lati);
    return reqxml;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: cityName,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Enter City name',
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        name = cityName.text.toString();
                        getData(name);
                        getDataXML(name);
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.lightGreen;
                        return Colors.green;
                        // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    if (jsonstate == false) {
                      setState(() {
                        jsonstate = true;
                      });
                    } else {
                      setState(() {
                        jsonstate = false;
                      });
                    }
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Text(
                      'Parse JSON Data',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.indigo;
                        return Colors.indigoAccent;
                        // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    if (xmstate == false) {
                      setState(() {
                        xmstate = true;
                      });
                    } else {
                      setState(() {
                        xmstate = false;
                      });
                    }
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Text(
                      'Parse XML Data',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                jsonstate == true && xmstate == false
                    ? Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'JSON Data',
                              style: GoogleFonts.poppins(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'City name: ${name}',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Text(
                              'Latitude : ${lat}',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Text(
                              'Longitude: ${long}',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Text(
                              'Temperature: ${temp}',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Text(
                              'Humidity: ${humidity}',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : jsonstate == false && xmstate == true
                        ? Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.indigoAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'XML Data',
                                  style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'City name: ${name}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Latitude : ${lati}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Longitude: ${longi}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Temperature: ${tempt}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Humidity: ${humidit}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'JSON Data',
                                  style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'City name: ${name}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Latitude : ${lat}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Longitude: ${long}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Temperature: ${temp}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Humidity: ${humidity}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
