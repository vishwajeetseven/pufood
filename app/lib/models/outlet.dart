class Outlet {
  final String name;
  final String menuLink;
  bool isFavorite;

  Outlet({required this.name, required this.menuLink, this.isFavorite = false});

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      name: json['name'] as String,
      menuLink: json['link'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'link': menuLink,
    'isFavorite': isFavorite,
  };
}
