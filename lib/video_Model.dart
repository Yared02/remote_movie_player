// Data class representing video information
class VideoData {
  final String videoTitle; // Title of the video
  final String videoUrl; // URL of the video
  final String videoThumbnail; // URL of the video thumbnail
  final String videoDescription; // Description of the video

  // Constructor to initialize VideoData instance
  VideoData({
    required this.videoTitle,
    required this.videoUrl,
    required this.videoThumbnail,
    required this.videoDescription,
  });

  // Factory method to create a VideoData instance from JSON data
  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      videoTitle: json['videoTitle'], // Extracting video title from JSON
      videoUrl: json['videoUrl'], // Extracting video URL from JSON
      videoThumbnail:
          json['videoThumbnail'], // Extracting video thumbnail URL from JSON
      videoDescription: json['videoDescription'] ??
          '', // Extracting video description from JSON (nullable)
    );
  }
}
