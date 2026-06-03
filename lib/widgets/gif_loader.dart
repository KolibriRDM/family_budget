import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class LoadingGif extends StatefulWidget {
  @override
  _LoadingGifState createState() => _LoadingGifState();
}

class _LoadingGifState extends State<LoadingGif>
    with SingleTickerProviderStateMixin {
  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 140,
        width: 140,
        child: Gif(
          controller: _gifController,
          autostart: Autostart.loop,
          placeholder: (context) =>
              const Center(child: CircularProgressIndicator()),
          image:
              const AssetImage('assets/gif/coin-flip-transparent-unscreen.gif'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }
}
