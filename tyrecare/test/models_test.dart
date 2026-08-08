import 'package:flutter_test/flutter_test.dart';
import 'package:tyrecare/models.dart';

void main() {
  final pneumatico = Pneumatico(
    posizione: 'antSx',
    pressioneBase: 2.4,
    usuraBase: 90,
    temperatura: 28,
  );

  test('keeps tyre wear within its supported range', () {
    expect(pneumatico.calcolaUsuraDinamica(0), 90);
    expect(pneumatico.calcolaUsuraDinamica(1500), 80);
    expect(pneumatico.calcolaUsuraDinamica(20000), 10);
  });

  test('calculates total vehicle mileage and average wear', () {
    final vehicle = Veicolo(
      nome: 'Test car',
      anno: '2024',
      chilometriIniziali: '1000',
      immagineUrl: '',
      antSx: pneumatico,
      antDx: pneumatico,
      postSx: pneumatico,
      postDx: pneumatico,
    );

    expect(vehicle.chilometriTotali(250.9), 1250);
    expect(vehicle.mediaUsuraGenerale(1500), 80);
  });
}
