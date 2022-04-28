import 'attributes.dart';
import 'post.dart';
import 'tag.dart';
import 'user.dart';

class Discussion extends Attributes {
  Discussion({
    required this.title,
    required this.slug,
    required this.commentCount,
    required this.participantCount,
    required this.createdAt,
    required this.lastPostedAt,
    required this.lastPostNumber,
    required this.canReply,
    required this.canRename,
    required this.canDelete,
    required this.canHide,
    required this.isApproved,
    required this.hasBestAnswer,
    this.bestAnswerSetAt,
    required this.subscription,
    required this.canTag,
    required this.canSplit,
    required this.isSticky,
    required this.canSticky,
    required this.isLocked,
    required this.canLock,
    // required this.fofPreventNecrobumping,
    required this.canMerge,
    required this.seeVotes,
    required this.canVote,
    required this.canEditRecipients,
    required this.canEditUserRecipients,
    required this.canEditGroupRecipients,
    required this.isPrivateDiscussion,
    required this.canSelectBestAnswer,
    required this.canViewWhoTypes,
    required this.replyTemplate,
    required this.canManageReplyTemplates,
    this.user,
    this.lastPostedUser,
    this.firstPost,
    this.tags,
  });

  String title;
  String slug;
  int commentCount;
  int participantCount;
  DateTime createdAt;
  DateTime lastPostedAt;
  int lastPostNumber;
  bool canReply;
  bool canRename;
  bool canDelete;
  bool canHide;
  bool isApproved;
  dynamic hasBestAnswer;
  DateTime? bestAnswerSetAt;
  dynamic subscription;
  bool canTag;
  bool canSplit;
  bool isSticky;
  bool canSticky;
  bool isLocked;
  bool canLock;
  // dynamic fofPreventNecrobumping;
  bool canMerge;
  bool seeVotes;
  bool canVote;
  bool canEditRecipients;
  bool canEditUserRecipients;
  bool canEditGroupRecipients;
  bool isPrivateDiscussion;
  bool canSelectBestAnswer;
  bool canViewWhoTypes;
  String replyTemplate;
  bool canManageReplyTemplates;

  // Relationships
  User? user;
  User? lastPostedUser;
  Post? firstPost;
  List<Tag>? tags;

  int? get bestAnswer => hasBestAnswer == false ? null : hasBestAnswer;

  factory Discussion.fromJson(Map<String, dynamic> json) => Discussion(
    title: json['title'],
    slug: json['slug'],
    commentCount: json['commentCount'] ?? 0,
    participantCount: json['participantCount'] ?? 0,
    createdAt: DateTime.parse(json['createdAt']),
    lastPostedAt: DateTime.parse(json['lastPostedAt']),
    lastPostNumber: json['lastPostNumber'],
    canReply: json['canReply'],
    canRename: json['canRename'],
    canDelete: json['canDelete'],
    canHide: json['canHide'],
    isApproved: json['isApproved'],
    hasBestAnswer: json['hasBestAnswer'],
    bestAnswerSetAt: json['bestAnswerSetAt'] != null ? DateTime.parse(json['bestAnswerSetAt']) : null,
    subscription: json['subscription'],
    canTag: json['canTag'],
    canSplit: json['canSplit'],
    isSticky: json['isSticky'],
    canSticky: json['canSticky'],
    isLocked: json['isLocked'],
    canLock: json['canLock'],
    // fofPreventNecrobumping: json['fof-prevent-necrobumping'],
    canMerge: json['canMerge'],
    seeVotes: json['seeVotes'],
    canVote: json['canVote'],
    canEditRecipients: json['canEditRecipients'],
    canEditUserRecipients: json['canEditUserRecipients'],
    canEditGroupRecipients: json['canEditGroupRecipients'],
    isPrivateDiscussion: json['isPrivateDiscussion'],
    canSelectBestAnswer: json['canSelectBestAnswer'],
    canViewWhoTypes: json['canViewWhoTypes'],
    replyTemplate: json['replyTemplate'],
    canManageReplyTemplates: json['canManageReplyTemplates'],

    user: json.containsKey('user') ? json['user'] : null,
    lastPostedUser: json.containsKey('lastPostedUser') ? json['lastPostedUser'] : null,
    firstPost: json.containsKey('firstPost') ? json['firstPost'] : null,
    tags: json.containsKey('firstPost') ? List<Tag>.from(json['firstPost'].map((x) => Tag.fromJson(x))) : null,
  );

  @override
  Map<String, dynamic> toJson() => {
    'title': title,
    'slug': slug,
    'commentCount': commentCount,
    'participantCount': participantCount,
    'createdAt': createdAt.toIso8601String(),
    'lastPostedAt': lastPostedAt.toIso8601String(),
    'lastPostNumber': lastPostNumber,
    'canReply': canReply,
    'canRename': canRename,
    'canDelete': canDelete,
    'canHide': canHide,
    'isApproved': isApproved,
    'hasBestAnswer': hasBestAnswer,
    'bestAnswerSetAt': bestAnswerSetAt,
    'subscription': subscription,
    'canTag': canTag,
    'canSplit': canSplit,
    'isSticky': isSticky,
    'canSticky': canSticky,
    'isLocked': isLocked,
    'canLock': canLock,
    // 'fof-prevent-necrobumping': fofPreventNecrobumping,
    'canMerge': canMerge,
    'seeVotes': seeVotes,
    'canVote': canVote,
    'canEditRecipients': canEditRecipients,
    'canEditUserRecipients': canEditUserRecipients,
    'canEditGroupRecipients': canEditGroupRecipients,
    'isPrivateDiscussion': isPrivateDiscussion,
    'canSelectBestAnswer': canSelectBestAnswer,
    'canViewWhoTypes': canViewWhoTypes,
    'replyTemplate': replyTemplate,
    'canManageReplyTemplates': canManageReplyTemplates,
  };
}
