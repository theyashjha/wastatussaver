// @dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mime_type/mime_type.dart';

import 'package:open_file/open_file.dart';

import 'package:path/path.dart';
import 'package:reonemoretimewaapp/utils/constants.dart';
import 'package:reonemoretimewaapp/utils/file_utils.dart';
import 'package:reonemoretimewaapp/utils/video_thumbnail.dart';

final Directory _videoDir =
    Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key key}) : super(key: key);
  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory('${_videoDir.path}').existsSync()) {
      return Scaffold(
        backgroundColor: Color(0xff075e54),
        appBar: AppBar(
          title: Center(child: Text("Status Saver")),
          elevation: 0,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: Colors.white),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.download_rounded,
                  color: Colors.green[100],
                  size: 180,
                ),
                const Text(
                  'Install WhatsApp.',
                  style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: 5,
                ),
                const Text(
                  "Your Friend's Status Will Be Available Here!🤗",
                  style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return
//        VideoGrid(directory: _videoDir);
          AltVideoGrid();
    }
  }
}

class AltVideoGrid extends StatefulWidget {
  @override
  _AltVideoGridState createState() => _AltVideoGridState();
}

class _AltVideoGridState extends State<AltVideoGrid> {
  List<FileSystemEntity> files = Directory(FileUtils.waPath).listSync()
    ..removeWhere((f) => basename(f.path).split("")[0] == ".");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff075e54),
      appBar: AppBar(
        title: Center(
            child: Text("Status Saver")), //app ka logo laga skte hain yahan
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            color: Colors.white),
        child: CustomScrollView(
          physics: const ScrollPhysics(),
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: SliverGrid.count(
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 5.0,
                crossAxisCount: 2,
                children: Constants.map(
                  files,
                  (index, item) {
                    FileSystemEntity f = files[index];
                    String path = f.path;
                    File file = File(path);
                    String mimeType = mime(path);
                    return mimeType == null
                        ? SizedBox()
                        : _WhatsAppItem(
                            file: file, path: path, mimeType: mimeType);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
//    ();
  }
}

class _WhatsAppItem extends StatelessWidget {
  final File file;
  final String path;
  final String mimeType;

  _WhatsAppItem({this.file, this.path, this.mimeType});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => OpenFile.open(file.path),
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: GridTile(
              child: mimeType.split("/")[0] == "video"
                  ? VideoThumbnail(path: path)
                  : Image(
                      fit: BoxFit.cover,
                      errorBuilder: (b, o, c) {
                        return Icon(Icons.image);
                      },
                      image: ResizeImage(
                        FileImage(File(file.path)),
                        width: 150,
                        height: 150,
                      ),
                    ),
              header: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              saveMedia();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                // margin: EdgeInsets.all(10),
                                // behavior: SnackBarBehavior.floating,
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.all(Radius.circular(20))
                                //   ),
                                backgroundColor: const Color(0xff075e54),
                                duration: const Duration(seconds: 1),
                                content: Text("Media Saved!"),
                              ));
                            },
                            icon: Icon(
                              Feather.download,
                              color: Colors.white,
                              size: 16.0,
                            ),
                          ),
                          mimeType.split("/")[0] == "video"
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "${FileUtils.formatBytes(file.lengthSync(), 1)}",
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                    ),
                                    SizedBox(width: 5.0),
                                    Icon(
                                      Icons.play_circle_filled,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  ],
                                )
                              : Text(
                                  "${FileUtils.formatBytes(file.lengthSync(), 1)}",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  saveMedia() async {
    String rootPath = '/storage/emulated/0/';
    await Directory("$rootPath${AppStrings.appName}").create();
    await Directory("$rootPath${AppStrings.appName}/Whatsapp Status").create();
    await file.copy(
        "$rootPath${AppStrings.appName}/Whatsapp Status/${basename(path)}");
    // Dialogs.showToast("Saved!");
  }
}

class AppStrings {
  //App related strings
  static String appName = "Status Saver";
}
//class VideoGrid extends StatefulWidget {
//  final Directory directory;
//
//  const VideoGrid({Key key, this.directory}) : super(key: key);
//
//  @override
//  _VideoGridState createState() => _VideoGridState();
//}
//
//class _VideoGridState extends State<VideoGrid> {
//  Future<String> _getImage(videoPathUrl) async {
//    //await Future.delayed(Duration(milliseconds: 500));
//    final thumb = await Thumbnails.getThumbnail(
//        videoFile: videoPathUrl,
//        imageType:
//            ThumbFormat.PNG, //this image will store in created folderpath
//        quality: 10);
//    return thumb;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final videoList = widget.directory
//        .listSync()
//        .map((item) => item.path)
//        .where((item) => item.endsWith('.mp4'))
//        .toList(growable: false);
//
//    if (videoList != null) {
//      if (videoList.length > 0) {
//        return Container(
//          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//          child: GridView.builder(
//            itemCount: videoList.length,
//            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//              crossAxisCount: 2,
//              childAspectRatio: 0.7,
//              mainAxisSpacing: 8.0,
//              crossAxisSpacing: 8,
//            ),
//            itemBuilder: (context, index) {
//              return InkWell(
//                onTap: () => Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => PlayStatus(
//                      videoFile: videoList[index],
//                    ),
//                  ),
//                ),
//                child: ClipRRect(
//                  borderRadius: const BorderRadius.all(Radius.circular(12)),
//                  child: Container(
//                    decoration: const BoxDecoration(
//                      gradient: LinearGradient(
//                        // Where the linear gradient begins and ends
//                        begin: Alignment.bottomLeft,
//                        end: Alignment.topRight,
//                        stops: [0.1, 0.3, 0.5, 0.7, 0.9],
//                        colors: [
//                          Color(0xffb7d8cf),
//                          Color(0xffb7d8cf),
//                          Color(0xffb7d8cf),
//                          Color(0xffb7d8cf),
//                          Color(0xffb7d8cf),
//                        ],
//                      ),
//                    ),
//                    child: FutureBuilder(
//                        future: _getImage(videoList[index]),
//                        builder: (context, snapshot) {
//                          if (snapshot.connectionState ==
//                              ConnectionState.done) {
//                            if (snapshot.hasData) {
//                              return Hero(
//                                tag: videoList[index],
//                                child: Image.file(
//                                  File(snapshot.data),
//                                  fit: BoxFit.cover,
//                                ),
//                              );
//                            } else {
//                              return const Center(
//                                child: CircularProgressIndicator(),
//                              );
//                            }
//                          } else {
//                            return Hero(
//                              tag: videoList[index],
//                              child: SizedBox(
//                                height: 280.0,
//                                child: Image.asset(
//                                    'images/wastatusapplogo.png'),
//                              ),
//                            );
//                          }
//                        }),
//                    //new cod
//                  ),
//                ),
//              );
//            },
//          ),
//        );
//      } else {
//        return const Center(
//          child: Text(
//            'Sorry, No Videos Found.',
//            style: TextStyle(fontSize: 18.0),
//          ),
//        );
//      }
//    } else {
//      return const Center(
//        child: CircularProgressIndicator(),
//      );
//    }
//  }
//}
