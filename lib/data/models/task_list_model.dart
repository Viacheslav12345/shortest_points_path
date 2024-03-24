class TaskList {
  final bool error;
  final String message;
  final List<Data>? data;

  const TaskList({
    required this.error,
    required this.message,
    required this.data,
  });

  factory TaskList.fromJson(Map<String, dynamic> json) {
    return TaskList(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: (json['data'] != null)
          ? (json['data'] as List).map((data) => Data.fromJson(data)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'error': error,
      'message': message,
      'data': data?.map((data) => data.toJson()).toList() ?? {},
    };
  }
}

class Data {
  String id;
  List<String> field;
  Coords start;
  Coords end;

  Data(
      {required this.id,
      required this.field,
      required this.start,
      required this.end});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      field: json['field'].cast<String>(),
      start: Coords.fromJson(json['start']),
      end: Coords.fromJson(json['end']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'field': field,
      'start': start.toJson(),
      'end': end.toJson(),
    };
  }
}

class Coords {
  int x;
  int y;

  Coords({required this.x, required this.y});

  factory Coords.fromJson(Map<String, dynamic> json) {
    return Coords(
      x: json['x'] as int,
      y: json['y'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'x': x,
      'y': y,
    };
  }

  Coords copyWith({
    int? x,
    int? y,
  }) {
    return Coords(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  bool operator ==(covariant Coords other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
