import 'package:biology_app/models/pharma_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/cupertino.dart';

class PharmaHome extends StatefulWidget{
  const PharmaHome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _PharmaHomeState createState() => _PharmaHomeState();

}

class _PharmaHomeState extends State<PharmaHome> {

  late YoutubePlayerController youtubePlayerController;

  List<PharmaModel> listOfUrls = [PharmaModel(id: 1, vidId: YoutubePlayerController.convertUrlToId("https://www.youtube.com/watch?v=VwL_mLz0V1Q&t=1033s")!),
    PharmaModel(id: 2, vidId: YoutubePlayerController.convertUrlToId("https://www.youtube.com/watch?v=7M5fhrM9L7E&t=494s")!),
    PharmaModel(id: 3, vidId: YoutubePlayerController.convertUrlToId("https://www.youtube.com/watch?v=tSrlXH3nf0Q&t=317s")!),
    PharmaModel(id: 4, vidId: YoutubePlayerController.convertUrlToId("https://www.youtube.com/watch?v=QuLv9SXaUA4&t=1139s")!),
    PharmaModel(id: 5, vidId: YoutubePlayerController.convertUrlToId("https://www.youtube.com/watch?v=ZbuH1YGjJjQ&t=256s")!),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        youtubePlayerController = YoutubePlayerController(
            initialVideoId: listOfUrls[0].vidId,
          params: YoutubePlayerParams(
            showFullscreenButton: true,
          )
        );
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    youtubePlayerController.close();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Pharmacologypedia'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildView(),
            buildMoreVidTitle(),
            buildMoreVidsView(),
          ],
        ),
      ),
    );
  }


  setOrientation(List<DeviceOrientation> devOrients) {
    SystemChrome.setPreferredOrientations(devOrients);
  }

  buildView() {
    return AspectRatio(
      aspectRatio: 16/9,
      child: youtubePlayerController != null
          ? YoutubePlayerIFrame(controller: youtubePlayerController)
          : Center(child: CircularProgressIndicator()
      ),
    );
  }

  buildMoreVidTitle() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 182, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'More Videos',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  buildMoreVidsView() {
    return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ListView.builder(
            itemCount: listOfUrls.length,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  final newVid = listOfUrls[index].vidId;
                  youtubePlayerController.load(newVid);
                  youtubePlayerController.stop();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height/5,
                  margin: EdgeInsets.symmetric(vertical: 7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Positioned(
                          child: CachedNetworkImage(
                            imageUrl: "https://d2jx2rerrg6sh3.cloudfront.net/image-handler/ts/20171124115709/ri/673/picture/2017/11/biophotonics_cell.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                            child: Align(
                              child: Image.asset(
                                'assets/play.png',
                              height: 30,
                                width: 30,
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              }
          ),
        ),
    );
  }
}