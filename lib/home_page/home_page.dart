import 'dart:math';

import 'package:flute_music/detail_page/song_detail_page.dart';
import 'package:flute_music/home_page/animated_progress.dart';
import 'package:flute_music/home_page/play_pause_button.dart';
import 'package:flute_music/home_page/song_card_details.dart';
import 'package:flute_music/neuromorphic_UI/neuromorphic_custom_styles.dart';
import 'package:flute_music/song_data/fetch_songs.dart';
import 'package:flute_music/theming/dynamic_theming._bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHomePage extends StatefulWidget {
  final ThemeBloc bloc;
  final bool isDark;
  MyHomePage(this.isDark, this.bloc);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  FetchSongs fetchSongs;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSongs = new FetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      drawer: _drawer(isDark: widget.isDark, bloc: widget.bloc),
      body: SafeArea(
        child: Column(
          children: [
            new Container(
              height: MediaQuery.of(context).size.height * 0.07,
              color: Theme.of(context).primaryColor,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(11.0),
                    child: InkWell(
                      onTap: () => _scaffoldKey.currentState.openDrawer(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: new Image(
                          image:
                              AssetImage('assets/images/abhishekProfile.JPG'),
                        ),
                      ),
                    ),
                  ),
                  NeumorphicButton(
                    margin: EdgeInsets.all(ScreenUtil().setWidth(15.0)),
                    boxShape: NeumorphicBoxShape.circle(),
                    onClick: () {},
                    style: widget.isDark ? dark_softUI : light_softUI,
                    child: new Icon(
                      Icons.search,
                      color: Theme.of(context).highlightColor,
                    ),
                  )
                ],
              ),
            ),
            new Expanded(
              child: new FutureBuilder(
                  future: fetchSongs.songs_list(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final SongInfo info = snapshot.data[index];
                            final double duration =
                                int.parse(info.duration) / 1000 / 60;

                            return Container(
                              height: MediaQuery.of(context).size.height * 0.09,
                              margin: index == 0
                                  ? EdgeInsets.only(top: 10.0)
                                  : null,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  new Expanded(
                                      flex: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Song_Detail_Page(info,widget.isDark)));
                                        },
                                        child: new Row(
                                          children: [
                                            new Expanded(
                                                flex: 1,
                                                child: Hero(
                                                  tag: info.filePath,
                                                  child: Container(
                                                    height: ScreenUtil()
                                                        .setHeight(95.0),
                                                    width: ScreenUtil()
                                                        .setHeight(95.0),
                                                    decoration: new BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: info.albumArtwork ==
                                                                null
                                                            ? Colors.primaries[
                                                                Random().nextInt(
                                                                    Colors
                                                                        .primaries
                                                                        .length)]
                                                            : Colors.black),
                                                  ),
                                                )),
                                            Song_Card_Details(
                                                info: info, duration: duration)
                                          ],
                                        ),
                                      )),
                                  Play_Pause_Button(widget: widget)
                                ],
                              ),
                            );
                          });
                    }
                    return animated_progress();
                  }),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _drawer extends StatelessWidget {
  const _drawer({
    Key key,
    @required this.isDark,
    @required this.bloc,
  }) : super(key: key);

  final bool isDark;
  final ThemeBloc bloc;

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: new Text("Dark Mode"),
            trailing: new Switch(
              value: this.isDark,
              onChanged: bloc.changeTheme,
            ),
          )
        ],
      ),
    );
  }
}