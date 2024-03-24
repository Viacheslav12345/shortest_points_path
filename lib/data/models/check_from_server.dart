class CheckFromServer {
  bool error;
  String message;
  List<DataCheck>? data;

  CheckFromServer(
      {required this.error, required this.message, required this.data});

  factory CheckFromServer.fromJson(Map<String, dynamic> json) {
    return CheckFromServer(
      error: json['error'],
      message: json['message'],
      data: (json['data'] != null)
          ? (json['data'] as List)
              .map((data) => DataCheck.fromJson(data))
              .toList()
          : null,
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

class DataCheck {
  String id;
  bool correct;

  DataCheck({required this.id, required this.correct});

  factory DataCheck.fromJson(Map<String, dynamic> json) {
    return DataCheck(
      id: json['id'],
      correct: json['correct'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'correct': correct,
    };
  }
}
