class Link{
  final String url;
  final bool isVisible;

  Link({required this.url, required this.isVisible});

  factory Link.empty(){
    return Link(url: "", isVisible: false);
  }

  factory Link.fromJson(Map<String, dynamic> json){
    return Link(
        url: json['url'],
        isVisible: json['isVisible']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'isVisible': isVisible,
    };
  }

}