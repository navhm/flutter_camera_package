import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'display_picture_screen.dart';

List<CameraDescription> cameras = [];

class CameraScreen extends StatefulWidget {
  static const String id = "video_recording_page";

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  bool isLoading = false;

  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    setState(() {
      isLoading = true; //Data is loading
    });
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    setState(() {
      isLoading = false; //Data has loaded
    });
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
            height: double.infinity,
            child: isLoading
                ? Container(
                    color: Colors.black,
                    height: double.infinity,
                    width: double.infinity,
                  )
                : CameraPreview(controller!)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black38,
                radius: 30,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.photo,
                      size: 30,
                      color: Colors.white,
                    )),
              ),
              CircleAvatar(
                backgroundColor: Colors.black38,
                radius: 30,
                child: IconButton(
                    onPressed: () async {
                      try {
                        final image = await controller!.takePicture();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayPictureScreen(
                              // Pass the automatically generated path to
                              // the DisplayPictureScreen widget.
                              imagePath: image.path,
                            ),
                          ),
                        );
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    },
                    icon: Icon(
                      Icons.camera,
                      size: 30,
                      color: Colors.white,
                    )),
              ),
              CircleAvatar(
                backgroundColor: Colors.black38,
                radius: 30,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.flip_camera_android,
                      size: 30,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
