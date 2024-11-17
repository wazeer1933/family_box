bool isImageUrl(String url) {
  // Define common image extensions
  final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg'];

  // Extract file extension from the URL
  final uri = Uri.parse(url);
  final extension = uri.path.split('.').last.toLowerCase();

  // Check if the extension is in the list of image extensions
  return imageExtensions.contains(extension);
}