class HomeMenu {
  String? title,subTitle;
  int? icon;

  HomeMenu({this.title, this.subTitle});

  HomeMenu.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['subTitle'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['subTitle'] = this.subTitle;
    data['icon'] = this.icon;
    return data;
  }
}
