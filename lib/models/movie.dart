class Movie {
  final int id;
  final String title;
  final String coverImg;
  final String description;
  final double duration;
  final String releaseDate;
  final String youtubeLink;
  final String status;

  Movie({
    required this.id,
    required this.title,
    required this.coverImg,
    required this.description,
    required this.duration,
    required this.releaseDate,
    required this.youtubeLink,
    required this.status,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: int.parse(json['id']),
      title: json['title'],
      coverImg: json['cover_img'],
      description: json['description'],
      duration: double.parse(json['duration'].toString()),
      releaseDate: json['release_date'],
      youtubeLink: json['youtube_link'],
      status: json['status'],
    );
  }
}
