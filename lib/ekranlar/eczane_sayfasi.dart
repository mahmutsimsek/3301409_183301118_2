import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Ecza> fetchEcza() async {
  final response = await http.get(
      Uri.parse('https://api.collectapi.com/health/dutyPharmacy?il=Ankara'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            'apikey 3ugM3AP4FVMM5qTJ2074ua:7oAZIMkUQDEsSh0ZDpkenu'
      });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Ecza.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Ecza {
  bool? success;
  List<Result>? result;

  Ecza({this.success, this.result});

  Ecza.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = success;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? name;
  String? dist;
  String? address;
  String? phone;
  String? loc;

  Result({this.name, this.dist, this.address, this.phone, this.loc});

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dist = json['dist'];
    address = json['address'];
    phone = json['phone'];
    loc = json['loc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dist'] = this.dist;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['loc'] = this.loc;
    return data;
  }
}

class eczane extends StatefulWidget {
  const eczane({super.key});

  @override
  State<eczane> createState() => _eczaneState();
}

class _eczaneState extends State<eczane> {
  late Future<Ecza> futureEcza;

  @override
  void initState() {
    super.initState();
    futureEcza = fetchEcza();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Nöcetçi Eczane'),
        ),
        body: Center(
          child: FutureBuilder<Ecza>(
            future: futureEcza,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data!.result![0].name);
                return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.result!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(

                            height: 50,
                            color: Colors.greenAccent,
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(' ${snapshot.data!.result![index].name}'),
                                Text('/ ${snapshot.data!.result![index].phone}'),
                                Text('/ ${snapshot.data!.result![index].dist}'),
                              ],
                            )),
                          ),
                          SizedBox(height: 10,)
                        ],
                      );
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),

      ),
    );
  }
}
