class USER {
  final String imagepath;
  final String name;
  final String email;
  final String about;
  final bool isDarckMode;
   final String? dateOfBirth;   // Nullable field
  final String? mobileNumber;  // Nullable field

  const USER({
    required this.imagepath,
    required this.name,
    required this.email,
    required this.about,
    required this.isDarckMode,
   this.dateOfBirth,   // Nullable
    this.mobileNumber,  // Nullable
  });

  USER copy({
    String? imagePath,
    String? name,
    String? email,
    String? about,
    bool? isDarkMode,
    String? dateOfBirth,    // Add parameter for date of birth
    String? mobileNumber,   // Add parameter for mobile number
  }) =>
      USER(
        imagepath: imagePath ?? this.imagepath,
        name: name ?? this.name,
        email: email ?? this.email,
        about: about ?? this.about,
        isDarckMode: isDarkMode ?? this.isDarckMode,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,  // Copy date of birth
        mobileNumber: mobileNumber ?? this.mobileNumber,  // Copy mobile number
      );

  static USER fromJson(Map<String, dynamic> json) => USER(
        imagepath: json['imagePath'],
        name: json['name'],
        email: json['email'],
        about: json['about'],
        isDarckMode: json['isDarkMode'],
       dateOfBirth: json['dateOfBirth'] ?? 'Unknown',  // Default value if null
  mobileNumber: json['mobileNumber'] ?? 'Unknown', // Default value if null
      );

  Map<String, dynamic> toJson() => {
        'imagePath': imagepath,
        'name': name,
        'email': email,
        'about': about,
        'isDarkMode': isDarckMode,
        'dateOfBirth': dateOfBirth,  // Serialize date of birth
        'mobileNumber': mobileNumber,  // Serialize mobile number
      };
}
