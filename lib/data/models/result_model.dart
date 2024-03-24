class ResultsForCheck {
  final String id;
  final Result result;

  const ResultsForCheck({
    required this.id,
    required this.result,
  });

  factory ResultsForCheck.fromJson(Map<String, dynamic> json) {
    return ResultsForCheck(
      id: json['id'],
      result: Result.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'result': result.toJson(),
    };
  }
}

class Result {
  List<Steps> steps;
  String path;

  Result({
    required this.steps,
    required this.path,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      steps:
          (json['steps'] as List).map((step) => Steps.fromJson(step)).toList(),
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'steps': steps.map((v) => v.toJson()).toList(),
      'path': path,
    };
  }
}

class Steps {
  String x;
  String y;

  Steps({required this.x, required this.y});

  factory Steps.fromJson(Map<String, dynamic> json) {
    return Steps(
      x: json['x'],
      y: json['y'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'x': x,
      'y': y,
    };
  }
}
