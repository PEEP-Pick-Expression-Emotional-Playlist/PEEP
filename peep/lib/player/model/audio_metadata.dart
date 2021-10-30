//태그 등 정보
class AudioMetadata {
  final String title;
  final String artist;
  final String artwork;
  final String year;
  final List emotions;
  final List genre;
  final List tags;

  AudioMetadata(this.title, this.artist, this.artwork, this.year, this.emotions, this.genre,
      this.tags);

  String getTags(){
    String tagStr = "";
    this.tags.forEach((tag)=>tagStr=tagStr+"#"+tag+" ");
    return tagStr;
  }
}