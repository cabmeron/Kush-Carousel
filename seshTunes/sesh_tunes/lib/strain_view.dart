import 'package:flutter/material.dart';
import 'strain_controller.dart';
import 'strain_model.dart';
import 'package:flutter/services.dart';
import 'dart:io';
// import 'song_model.dart';
// import 'song_view.dart';

class StrainView extends StatefulWidget {
  const StrainView({Key? key}) : super(key: key);

  @override
  State<StrainView> createState() => _StrainViewState();
}

class _StrainViewState extends State<StrainView> {
  final StrainController _controller = StrainController();
  List<Strain> strains = [];
  int currentIndex = 0;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStrains();
  }

  String spotifyUri =
      'spotify:artist:2YfFYZnshSzgfLsKZMM4VL'; // Replace with your Spotify URI

  Future<void> _loadStrains() async {
    final loadedStrains = await _controller.loadStrains();
    setState(() {
      strains = loadedStrains;
    });
  }

  Future<void> runPythonScript() async {
    try {
      final result = await Process.run('python', ['sesh_tunes/lib/main.py']);
      print(result.stdout);
    } catch (e) {
      // ERROR
      print("ERROR");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (strains.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double carouselWidth = screenWidth * 0.55; // 80% of the screen width

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KUSH Carousel',
          style: TextStyle(
            fontSize: 40,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: carouselWidth,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Email For Song Request',
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // HARDCODED URI FOR TEST USE WITH SPOTIFY WEB VIEW
                      // NOT CURRENTLY IN USE
                      String hardcodedUri =
                          'spotify:artist:430byzy0c5bPn5opiu0SRd';
                      print('Submitted Name: ${nameController.text}');
                      await Clipboard.setData(
                          ClipboardData(text: hardcodedUri));
                      // OPEN SPOTIFY BROWSER FOR URI DISPLAY
                      // NO IMPLEMENTATION
                      // SPOTIFY API SCRIPT BELOW, CURRENTLY BROKEN USING
                      // LOCAL HOST, TRY A FLASK SERVER FOR FUTURE
                      // runPythonScript();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Name: ${strains[currentIndex].name}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Image.network(
                                    strains[currentIndex].imgUrl,
                                    height: 350,
                                    width: 350,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Type: ${strains[currentIndex].type}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Effects:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                for (var effect
                                    in strains[currentIndex].effects.entries)
                                  Text(
                                    '${effect.key}: ${effect.value}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        height: 160,
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Text(
                            'Description: ${strains[currentIndex].description}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentIndex = (currentIndex - 1 + strains.length) %
                            strains.length;
                      });
                    },
                    child: const Text('Previous Strain'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentIndex = (currentIndex + 1) % strains.length;
                      });
                    },
                    child: const Text('Next Strain'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
