# flutter_image_crop_plugin_example

```dart
    FlutterImageCropPlugin.getImage((imageData) {
      setState(() {
        _imageData = imageData;
      });
    });

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          width: 375,
          height: 667,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: <Widget>[
                    Container(
                      width: 375,
                      height: 667,
                      child: FlutterImageCropPlugin.imageCropWidget(_setCreationParams(snapshot.data)),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        height: 100,
                        width: 100,
                        child: (_imageData == null) ? Container() : Image.memory(_imageData),
                      ),
                    )
                  ],
                );
              } else {
                return Container();
              }
            },
            future: _future,
          ),
        ),
      ),
    );
  }

  Map _setCreationParams(String imageBase64) {
    return {
      'toCropImage': imageBase64,
      'showMidLines': false,
      'needScaleCrop': false,
      'showCrossLines': false,
      'cornerBorderInImage': false,
      'cropAreaCornerWidth': 44,
      'cropAreaCornerHeight': 44,
      'minSpace': 30,
      'cropAreaCornerLineWidth': 3,
      'cropAreaBorderLineWidth': 0,
      'cropAreaMidLineWidth': 0,
      'cropAreaMidLineHeight': 0,
      'cropAreaCrossLineWidth': 0,
      'cropAspectRatio': 0,
    };
  }

  Future<String> _getImageData() async {
    ByteData imageData = await rootBundle.load('images/image.jpeg');
    String imageBase64 = base64Encode(imageData.buffer.asUint8List());
    return imageBase64;
  }
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
