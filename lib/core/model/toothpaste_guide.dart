class ToothpasteGuide{
  final String id;
  final String title;
  final String content;

  ToothpasteGuide({required this.id, required this.title, required this.content});

  factory ToothpasteGuide.fromJson(Map<String, dynamic> json){
    return ToothpasteGuide(
        id: json['id'],
        title: json['title'],
        content: json['content']
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'title': title,
      'content': content
    };
    return json;
  }

}