import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_wallpaper/view/screens/home/all_photos_screen.dart';
import 'package:my_wallpaper/view/screens/home/natural_screen.dart';


class Api1 extends StatefulWidget {
  @override
  _Api1State createState() => _Api1State();
}

class _Api1State extends State<Api1> {
  Future<List<dynamic>> _getData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<dynamic> data = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(data[index]['title']),
                  subtitle: Text(data[index]['body']),
                );
              },
            );
          } else {
            return Text('Failed to load data from API');
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Api2 extends StatefulWidget {
  @override
  _Api2State createState() => _Api2State();
}

class _Api2State extends State<Api2> {
  Future<List<dynamic>> _getData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<dynamic> data = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(data[index]['name']),
                  subtitle: Text(data[index]['email']),
                );
              },
            );
          } else {
            return Text('Failed to load data from API');
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AllPhotosScreen(),
            NaturalScreen()
            // Api1(),
            // Api2(),
          ],
        ),
      ),
    );
  }
}
