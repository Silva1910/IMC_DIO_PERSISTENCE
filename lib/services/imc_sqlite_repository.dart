import 'package:imc_application/model/imcSQLiteModel.dart';
import 'package:imc_application/services/app_storage_service.dart';

class ImcSQLiteRepository {
  Future<List<imcSQLiteModel>> obterDados(bool apenasNaoConcluidos) async {
    List<imcSQLiteModel> tableImc = [];
    var db = await SQLiteDataBase().obterDataBase();
    var result = await db.query('CALCULO_IMC');
    for (var row in result) {
      var imc = imcSQLiteModel();
      imc.id = row['id'] as int;
      imc.altura = row['altura'] is int
          ? (row['altura'] as int).toDouble()
          : row['altura'] as double;
      imc.peso = row['peso'] is int
          ? (row['peso'] as int).toDouble()
          : row['peso'] as double;
      tableImc.add(imc);
    }
    print("Dados do banco de dados: $tableImc");
    return tableImc;
  }

  Future<void> salvar(imcSQLiteModel imcSQLiteModel) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.insert('CALCULO_IMC', {
      'altura': imcSQLiteModel.getAltura(),
      'peso': imcSQLiteModel.getPeso(),
      'IMC': imcSQLiteModel.getImc()
    });
  }

  Future<void> atualizar(imcSQLiteModel imcSQLiteModel) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.update(
      'CALCULO_IMC',
      {
        'altura': imcSQLiteModel.getAltura(),
        'peso': imcSQLiteModel.getPeso(),
        'IMC': imcSQLiteModel.getImc()
      },
      where: 'id = ?',
      whereArgs: [imcSQLiteModel.getID()],
    );
  }

  Future<void> remover(int id) async {
    var db = await SQLiteDataBase().obterDataBase();
    await db.delete('CALCULO_IMC', where: 'id = ?', whereArgs: [id]);
  }
}
