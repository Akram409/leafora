class DiseaseModel {
  final String diseaseId;
  final String diseaseName;
  final String diseaseImage;
  final String diseaseType;
  final Description description;
  final int? helpful;
  final int? notHelpful;

  DiseaseModel({
    required this.diseaseId,
    required this.diseaseName,
    required this.diseaseImage,
    required this.diseaseType,
    required this.description,
    this.helpful,
    this.notHelpful,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      diseaseId: json['diseaseId'],
      diseaseName: json['diseaseName'],
      diseaseImage: json['diseaseImage'],
      diseaseType: json['diseaseType'],
      description: Description.fromJson(json['description']),
      helpful: json['helpful'],
      notHelpful: json['not_helpful'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['diseaseId'] = this.diseaseId;
    data['diseaseName'] = this.diseaseName;
    data['diseaseImage'] = this.diseaseImage;
    data['diseaseType'] = this.diseaseType;
    data['description'] = this.description.toJson();
    data['helpful'] = this.helpful;
    data['not_helpful'] = this.notHelpful;
    return data;
  }
}

class Description {
  List<Ops> ops;

  Description({required this.ops});

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      ops: (json['ops'] as List)
          .map((v) => Ops.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ops': this.ops.map((v) => v.toJson()).toList(),
    };
  }
}

class Ops {
  String insert;
  Attributes? attributes;

  Ops({required this.insert, this.attributes});

  factory Ops.fromJson(Map<String, dynamic> json) {
    return Ops(
      insert: json['insert'],
      attributes: json['attributes'] != null
          ? Attributes.fromJson(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['insert'] = this.insert;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    return data;
  }
}

class Attributes {
  bool? bold;
  int? header;

  Attributes({this.bold, this.header});

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      bold: json['bold'],
      header: json['header'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bold': this.bold,
      'header': this.header,
    };
  }
}
