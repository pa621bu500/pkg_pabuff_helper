class MdlPagRole {
  int id;
  String name;
  String? label;
  int rank;

  MdlPagRole({
    required this.id,
    required this.name,
    this.label,
    this.rank = -1,
  });

  factory MdlPagRole.fromJson(Map<String, dynamic> json) {
    dynamic id = json['id'];
    if (id is String) {
      id = int.parse(id);
    }

    dynamic rank = json['rank'] ?? -1;
    if (rank is String) {
      rank = int.tryParse(rank);
    }

    return MdlPagRole(
      id: id,
      name: json['name'],
      label: json['label'],
      rank: rank,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'label': label,
      'rank': rank,
    };
  }
}
