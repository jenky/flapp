class User {
  User({
    required this.username,
    required this.displayName,
    this.avatarUrl,
    required this.slug,
    this.joinTime,
    this.discussionCount,
    this.commentCount,
    this.canEdit,
    this.canEditCredentials,
    this.canEditGroups,
    this.canDelete,
    this.lastSeenAt,
    this.canSuspend,
    this.usernameHistory,
    this.bio,
    this.canViewBio,
    this.canEditBio,
    this.canSpamblock,
    this.canViewRankingPage,
    this.points,
    this.blocksPd,
    this.cannotBeDirectMessaged,
    this.canViewWarnings,
    this.canManageWarnings,
    this.canDeleteWarnings,
    this.visibleWarningCount,
  });

  String username;
  String displayName;
  String? avatarUrl;
  String slug;
  DateTime? joinTime;
  int? discussionCount;
  int? commentCount;
  bool? canEdit;
  bool? canEditCredentials;
  bool? canEditGroups;
  bool? canDelete;
  DateTime? lastSeenAt;
  bool? canSuspend;
  List? usernameHistory;
  String? bio;
  bool? canViewBio;
  bool? canEditBio;
  bool? canSpamblock;
  bool? canViewRankingPage;
  int? points;
  bool? blocksPd;
  bool? cannotBeDirectMessaged;
  bool? canViewWarnings;
  bool? canManageWarnings;
  bool? canDeleteWarnings;
  int? visibleWarningCount;

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json['username'],
    displayName: json['displayName'],
    avatarUrl: json['avatarUrl'],
    slug: json['slug'],
    joinTime: json['joinTime'] != null ? DateTime.parse(json['joinTime']) : null,
    discussionCount: json['discussionCount'],
    commentCount: json['commentCount'],
    canEdit: json['canEdit'],
    canEditCredentials: json['canEditCredentials'],
    canEditGroups: json['canEditGroups'],
    canDelete: json['canDelete'],
    lastSeenAt: json['lastSeenAt'] != null ? DateTime.parse(json['lastSeenAt']) : null,
    canSuspend: json['canSuspend'],
    usernameHistory: json['usernameHistory'],
    bio: json['bio'],
    canViewBio: json['canViewBio'],
    canEditBio: json['canEditBio'],
    canSpamblock: json['canSpamblock'],
    canViewRankingPage: json['canViewRankingPage'],
    points: json['points'],
    blocksPd: json['blocksPd'],
    cannotBeDirectMessaged: json['cannotBeDirectMessaged'],
    canViewWarnings: json['canViewWarnings'],
    canManageWarnings: json['canManageWarnings'],
    canDeleteWarnings: json['canDeleteWarnings'],
    visibleWarningCount: json['visibleWarningCount'],
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'displayName': displayName,
    'avatarUrl': avatarUrl,
    'slug': slug,
    'joinTime': joinTime?.toIso8601String(),
    'discussionCount': discussionCount,
    'commentCount': commentCount,
    'canEdit': canEdit,
    'canEditCredentials': canEditCredentials,
    'canEditGroups': canEditGroups,
    'canDelete': canDelete,
    'lastSeenAt': lastSeenAt?.toIso8601String(),
    'canSuspend': canSuspend,
    'usernameHistory': usernameHistory,
    'bio': bio,
    'canViewBio': canViewBio,
    'canEditBio': canEditBio,
    'canSpamblock': canSpamblock,
    'canViewRankingPage': canViewRankingPage,
    'points': points,
    'blocksPd': blocksPd,
    'cannotBeDirectMessaged': cannotBeDirectMessaged,
    'canViewWarnings': canViewWarnings,
    'canManageWarnings': canManageWarnings,
    'canDeleteWarnings': canDeleteWarnings,
    'visibleWarningCount': visibleWarningCount,
  };
}
