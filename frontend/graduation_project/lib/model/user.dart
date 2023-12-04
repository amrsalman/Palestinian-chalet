class USER {
  final String imagepath;
    final String name;
      final String email;
        final String about;
          final bool isDarckMode;


          const USER({
  required this.imagepath,
  required this.name,
  required this.email,
  required this.about,
  required this.isDarckMode,
  

}

);
 USER copy({
    String? imagePath,
    String? name,
    String? email,
    String? about,
    bool? isDarkMode,
  }) =>
  USER(
        imagepath: imagePath ?? this.imagepath,
        name: name ?? this.name,
        email: email ?? this.email,
        about: about ?? this.about,
        isDarckMode: isDarkMode ?? this.isDarckMode,
      );
      
  static USER fromJson(Map<String, dynamic> json) => USER(
        imagepath: json['imagePath'],
        name: json['name'],
        email: json['email'],
        about: json['about'],
        isDarckMode: json['isDarkMode'],
      );
Map<String, dynamic> toJson() => {
        'imagePath': imagepath,
        'name': name,
        'email': email,
        'about': about,
        'isDarkMode': isDarckMode,
      };




}

