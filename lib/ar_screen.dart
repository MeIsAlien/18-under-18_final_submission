import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'global_variables.dart';

class ARScreen extends StatefulWidget {
  final String entity;

  const ARScreen({Key key, this.entity}) : super(key: key);

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  String entity;
  ArCoreController arCoreController;

  @override
  void initState() {
    super.initState();
    this.entity = widget.entity;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: tColor,
          title: Row(children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                size: 28,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 45, height: 0),
            Text(entity)
          ]),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
//    _addEntityNode(arCoreController);
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _addEntityNode(ArCoreHitTestResult plane) {
    final entityNode = ArCoreReferenceNode(
      name: entity,
      objectUrl: objectKeys[entity.toLowerCase()]["3d_model_URI"],
      position: plane.pose.translation,
      rotation: plane.pose.rotation,
//      scale: vector.Vector3(0.1, 0.1, 0.1)
    );

    arCoreController.addArCoreNodeWithAnchor(entityNode);
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addEntityNode(hit);
  }

  void onTapHandler(String name) {
    print("Flutter: onNodeTap");
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Row(
          children: <Widget>[
            Text('Remove $name?'),
            IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  arCoreController.removeNode(nodeName: name);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
