class Links
{
  Links({
    required this.first,
    required this.next,
  });

  String first;
  String next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json['first'],
    next: json['next'],
  );

  Map<String, dynamic> toJson() => {
    'first': first,
    'next': next,
  };
}
