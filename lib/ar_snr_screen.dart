import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'global_variables.dart';

class AugmentedPage extends StatefulWidget {
  @override
  _AugmentedPageState createState() => _AugmentedPageState();
}

class _AugmentedPageState extends State<AugmentedPage> {
  ArCoreController arCoreController;
  Map<int, ArCoreAugmentedImage> augmentedImagesMap = Map();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Scan n' Render"),
            backgroundColor: tColor,
          ),
          body: Stack(
            children: [
              ArCoreView(
                onArCoreViewCreated: _onArCoreViewCreated,
                type: ArCoreViewType.AUGMENTEDIMAGES,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: Colors.blueGrey),
                  ),
                  width: MediaQuery.of(context).size.width/1.2,
                  height: MediaQuery.of(context).size.width/1.2,
                ),
              )
            ],
          )),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) async {
    arCoreController = controller;
    arCoreController.onTrackingImage = _handleOnTrackingImage;
    await loadImagesDatabase();
  }

  loadImagesDatabase() async {
    final ByteData imgDBbytes = await rootBundle.load('assets/myimages.imgdb');
    arCoreController.loadAugmentedImagesDatabase(
        bytes: imgDBbytes.buffer.asUint8List());
  }

  _handleOnTrackingImage(ArCoreAugmentedImage augmentedImage) {
    if (!augmentedImagesMap.containsKey(augmentedImage.index)) {
      augmentedImagesMap[augmentedImage.index] = augmentedImage;
      _addModel(augmentedImage);
    }
  }

  Future _addModel(ArCoreAugmentedImage augmentedImage) async {
    final entityNode = ArCoreReferenceNode(
      name: augmentedImage.name,
      objectUrl:
          "${objectKeys[augmentedImage.name.replaceAll(".png", "").replaceAll(".jpg", "").toLowerCase()]["3d_model_URI"]}",
      //position: vector.Vector3(0, 2, 0),
    );
    arCoreController.addArCoreNodeToAugmentedImage(
        entityNode, augmentedImage.index);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
