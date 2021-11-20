import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:peep/player/audio_manager.dart';

class NowPlayingPage extends StatefulWidget{
  _NowPlayingPageState createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        title: Text(
          '재생 목록',
        ),),
      body: Container(
        height: double.infinity,
        child: StreamBuilder<SequenceState>(
          stream: AudioManager.instance.player.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            final sequence = state?.sequence ?? [];
            return ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) newIndex--;
                AudioManager.instance.playlist.move(oldIndex, newIndex);
              },
              children: [
                for (var i = 0; i < sequence.length; i++)
                  Dismissible(
                    key: ValueKey(sequence[i]),
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    onDismissed: (dismissDirection) {
                      AudioManager.instance.playlist.removeAt(i);
                    },
                    child: Material(
                      color: i == state.currentIndex
                          ? Colors.grey.shade300
                          : null,
                      child: ListTile(
                        title: Text(sequence[i].tag.title as String),
                        onTap: () {
                          AudioManager.instance.player.seek(Duration.zero, index: i);
                        },
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

}