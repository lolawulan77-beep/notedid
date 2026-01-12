class Note {
  final int? id;
  final String title;

  Note({this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}
