class PlantModel {
  String? plantId;
  String? plantImage;
  String? plantName;
  String? scientificName;
  String? plantType;
  String? genus;
  String? plantDescription;
  Description? description;
  int? helpful;
  int? notHelpful;
  String? author;

  PlantModel(
      {required this.plantId,
      required this.plantImage,
      required this.plantName,
      required this.scientificName,
      required this.plantType,
      required this.genus,
      required this.plantDescription,
      required this.description,
      this.helpful,
      this.notHelpful,
      required this.author});

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      plantId: json['plantId'],
      plantImage: json['plantImage'],
      plantName: json['plantName'],
      scientificName: json['scientificName'],
      plantType: json['plantType'],
      genus: json['genus'],
      plantDescription: json['plantDescription'],
      description: Description.fromJson(json['description']),
      helpful: json['helpful'],
      notHelpful: json['notHelpful'],
      author: json['author'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plantId'] = this.plantId;
    data['plantImage'] = this.plantImage;
    data['plantName'] = this.plantName;
    data['scientificName'] = this.scientificName;
    data['plantType'] = this.plantType;
    data['genus'] = this.genus;
    data['plantDescription'] = this.plantDescription;
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    data['helpful'] = this.helpful;
    data['not_helpful'] = this.notHelpful;
    data['author'] = this.author;
    return data;
  }
}

class Description {
  List<Ops>? ops;

  Description({this.ops});

  Description.fromJson(Map<String, dynamic> json) {
    if (json['ops'] != null) {
      ops = <Ops>[];
      json['ops'].forEach((v) {
        ops!.add(new Ops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ops != null) {
      data['ops'] = this.ops!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ops {
  String? insert;
  Attributes? attributes;

  Ops({this.insert, this.attributes});

  Ops.fromJson(Map<String, dynamic> json) {
    insert = json['insert'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

  Attributes.fromJson(Map<String, dynamic> json) {
    bold = json['bold'];
    header = json['header'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bold'] = this.bold;
    data['header'] = this.header;
    return data;
  }
}
