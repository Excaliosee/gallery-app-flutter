import 'dart:convert';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

void main() => runApp(const GalleryApp());

class GalleryApp extends StatelessWidget{
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery App',
      color: Colors.deepPurple.shade400,
      home: const HomePage(), 
    );
  }
}

class HomePage extends StatefulWidget{

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> pictures = [];
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async{
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    setState(() {
      pictures = manifestMap.keys
        .where((String key) => key.startsWith('assets/images/'))
        .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gallery',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.blue.shade100,
      ),
      backgroundColor: Colors.black,
      body: isLoading ? const Center(child: CircularProgressIndicator()) : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: pictures.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: () => _showFullScreen(context, index),
            child: ClipRRect(
              child: Image.asset(
                pictures[index],
                fit: BoxFit.cover,
              ),        
            ),
          );
        },
      ),
    );
  }

  void _showFullScreen(BuildContext context, int index){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenPage(pictures: pictures, initialIndex: index),
      )
    );
  }
}

class FullScreenPage extends StatelessWidget{
  final List<String> pictures;
  final int initialIndex;

  const FullScreenPage({super.key, required this.pictures, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: pictures.length,
        itemBuilder: (context, index){
          return Center(
            child: PhotoView(
              imageProvider: AssetImage(pictures[index]),
            ),
          );
        }
      )
    );
  }
}