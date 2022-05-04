class Post {
  Post({
    required this.number,
    required this.createdAt,
    required this.contentType,
    this.content,
    required this.contentHtml,
    this.editedAt,
    this.canEdit,
    this.canDelete,
    this.canHide,
    this.canFlag,
    this.isApproved,
    this.canApprove,
    this.votes,
    this.canVote,
    this.seeVoters,
    this.canLike,
  });

  int number;
  DateTime createdAt;
  String contentType;
  dynamic content;
  String? contentHtml;
  DateTime? editedAt;
  bool? canEdit;
  bool? canDelete;
  bool? canHide;
  bool? canFlag;
  bool? isApproved;
  bool? canApprove;
  dynamic votes;
  bool? canVote;
  bool? seeVoters;
  bool? canLike;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    number: json['number'],
    createdAt: DateTime.parse(json['createdAt']),
    contentType: json['contentType'],
    content: json.containsKey('content') ? json['content'] : null,
    contentHtml: json.containsKey('contentHtml') ? json['contentHtml'] : null,
    editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt']) : null,
    canEdit: json['canEdit'],
    canDelete: json['canDelete'],
    canHide: json['canHide'],
    canFlag: json['canFlag'],
    isApproved: json['isApproved'],
    canApprove: json['canApprove'],
    votes: json['votes'],
    canVote: json['canVote'],
    seeVoters: json['seeVoters'],
    canLike: json['canLike'],
  );

  Map<String, dynamic> toJson() => {
    'number': number,
    'createdAt': createdAt.toIso8601String(),
    'contentType': contentType,
    // 'content': content,
    'contentHtml': contentHtml,
    'canEdit': canEdit,
    'canDelete': canDelete,
    'canHide': canHide,
    'canFlag': canFlag,
    'isApproved': isApproved,
    'canApprove': canApprove,
    'votes': votes,
    'canVote': canVote,
    'seeVoters': seeVoters,
    'canLike': canLike,
  };
}
