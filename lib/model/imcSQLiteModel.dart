
class imcSQLiteModel {
  int _id = 0;
  double _peso = 0;
  double _altura = 0;
  double _imc = 0;

  int getID() => _id;
  double getPeso() => _peso;
  double getAltura() => _altura;
  double getImc() => getPeso() / (getAltura() * getAltura());
  set peso(double peso) => _peso = peso;
  set altura(double altura) => _altura = altura;
  set id(int id) => _id = id;

  calculo(altura, peso) {
    _imc = peso / (altura * altura);

    if (_imc < 16) {
      return "MAGREZA GRAVE";
    } else if (_imc >= 16 && _imc < 17) {
      return "MAGREZA MODERADA";
    } else if (_imc >= 17 && _imc < 18.5) {
      return "MAGREZA LEVE";
    } else if (_imc >= 18.5 && _imc < 25) {
      return "SAUDÁVEL";
    } else if (_imc >= 25 && _imc < 30) {
      return "SOBREPESO";
    } else if (_imc >= 30 && _imc < 35) {
      return "OBESIDADE GRAU I";
    } else if (_imc >= 35 && _imc < 40) {
      return "OBESIDADE GRAU II";
    } else {
      return "OBESIDADE GRAU III";
    }
  }
}
