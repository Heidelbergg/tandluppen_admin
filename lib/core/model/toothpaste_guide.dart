class ToothpasteGuide{
  final String id;
  final String title;
  final String content;
  final int order;

  ToothpasteGuide({required this.id, required this.title, required this.content, required this.order});

  factory ToothpasteGuide.fromJson(Map<String, dynamic> json){
    return ToothpasteGuide(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        order: json['order']
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'title': title,
      'content': content,
      'order': order
    };
    return json;
  }

}