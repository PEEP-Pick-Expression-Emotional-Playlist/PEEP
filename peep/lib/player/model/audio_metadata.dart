//태그 등 정보
class AudioMetadata {
  final String key;
  final String title;
  final String artist;
  final String artwork;
  final String year;
  final List emotions;
  final List genre;
  final List tags;
  int _favorite;
  final Duration duration;

  AudioMetadata(this.key, this.title, this.artist, this.artwork, this.year, this.emotions, this.genre,
      this.tags, this._favorite, this.duration);

  set favorite(int value) {
    _favorite = value;
  }


  int get favorite => _favorite;

  String getTags(){
    String tagStr = "";
    this.tags.forEach((tag)=>tagStr=tagStr+"#"+tag+" ");
    return tagStr;
  }
}