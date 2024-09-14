class RegisterModel {
  String starID;

  RegisterModel({
    this.starID = '',
  });

  @override
  String toString() {
    return 'Star ID: $starID';
  }
}
