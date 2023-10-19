class UserModel {
  final int id;
  final String namaLengkap;
  final String namaPanggilan;
  final String email;
  final String role;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.namaLengkap,
    required this.namaPanggilan,
    required this.email,
    required this.role,
    this.photoUrl,
  });
}
