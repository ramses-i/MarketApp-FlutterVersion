import 'package:equatable/equatable.dart';

class Picture extends Equatable {
  const Picture({required this.id, required this.secureURL});

  final int id;
  final String secureURL;

  @override
  List<Object> get props => [id, secureURL];
}
