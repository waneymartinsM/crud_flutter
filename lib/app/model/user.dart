class UserModel {
  String userImage;
  String name;
  String email;
  String cpf;
  String phone;
  String password;
  String maritalStatus;
  String genre;

  UserModel({
    this.userImage = '',
    this.name = '',
    this.email = '',
    this.cpf = '',
    this.phone = '',
    this.password = '',
    this.maritalStatus = '',
    this.genre = '',
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "userImage": userImage,
      "name": name,
      "email": email,
      "cpf": cpf,
      "genre": genre,
      "phone": phone,
      "maritalStatus": maritalStatus,
    };
    return map;
  }

  factory UserModel.fromMap(Map<dynamic, dynamic>? dados) {
    return UserModel(
      userImage: dados?['imagem_usuario'] ?? '',
      name: dados?['name'] ?? '',
      email: dados?['email'] ?? '',
      cpf: dados?['cpf'] ?? '',
      genre: dados?['sexo'] ?? '',
      phone: dados?['phone'] ?? '',
      maritalStatus: dados?['estado_civil'] ?? '',
      password: dados?['password'] ?? '',
    );
  }

  factory UserModel.clean() {
    return UserModel(name: '', email: '',);
  }
}
