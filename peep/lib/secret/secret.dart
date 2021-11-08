class Secret {
  final String webUrl;
  Secret({this.webUrl = ""});
  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(webUrl: jsonMap["web_url"]);
  }
}