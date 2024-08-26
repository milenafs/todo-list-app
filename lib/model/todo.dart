class ToDo {
  String id;
  String todoText;
  bool isFavorited;
  bool isDone;
  DateTime? startDate;
  DateTime? endDate;

  ToDo({
    required this.id,
    required this.todoText,
    required this.isFavorited,
    required this.isDone,
    required this.startDate,
    required this.endDate,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      todoText: json['todoText'],
      isFavorited: json['isFavorited'],
      isDone: json['isDone'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todoText': todoText,
      'isFavorited': isFavorited,
      'isDone': isDone,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
