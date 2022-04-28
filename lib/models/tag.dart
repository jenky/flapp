class Tag
{
  Tag({
    required this.name,
    required this.description,
    required this.slug,
    required this.color,
    this.backgroundUrl,
    this.backgroundMode,
    this.icon,
    required this.discussionCount,
    this.position,
    required this.defaultSort,
    required this.isChild,
    required this.isHidden,
    this.lastPostedAt,
    required this.canStartDiscussion,
    required this.canAddToDiscussion,
    this.subscription,
    required this.isQnA,
    required this.reminders,
    required this.template,
  });

  String name;
  String description;
  String slug;
  String color;
  String? backgroundUrl;
  String? backgroundMode;
  String? icon;
  int discussionCount;
  int? position;
  dynamic defaultSort;
  bool isChild;
  bool isHidden;
  DateTime? lastPostedAt;
  bool canStartDiscussion;
  bool canAddToDiscussion;
  dynamic subscription;
  bool isQnA;
  bool reminders;
  String template;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    name: json['name'],
    description: json['description'],
    slug: json['slug'],
    color: json['color'],
    backgroundUrl: json['backgroundUrl'],
    backgroundMode: json['backgroundMode'],
    icon: json['icon'],
    discussionCount: json['discussionCount'],
    position: json['position'],
    defaultSort: json['defaultSort'],
    isChild: json['isChild'],
    isHidden: json['isHidden'],
    lastPostedAt: json['lastPostedAt'] != null ? DateTime.parse(json['lastPostedAt']) : null,
    canStartDiscussion: json['canStartDiscussion'],
    canAddToDiscussion: json['canAddToDiscussion'],
    subscription: json['subscription'],
    isQnA: json['isQnA'],
    reminders: json['reminders'],
    template: json['template'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'slug': slug,
    'color': color,
    'backgroundUrl': backgroundUrl,
    'backgroundMode': backgroundMode,
    'icon': icon,
    'discussionCount': discussionCount,
    'position': position,
    'defaultSort': defaultSort,
    'isChild': isChild,
    'isHidden': isHidden,
    'lastPostedAt': lastPostedAt?.toIso8601String(),
    'canStartDiscussion': canStartDiscussion,
    'canAddToDiscussion': canAddToDiscussion,
    'subscription': subscription,
    'isQnA': isQnA,
    'reminders': reminders,
    'template': template,
  };
}
