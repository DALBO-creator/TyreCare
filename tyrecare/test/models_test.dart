import 'package:flutter_test/flutter_test.dart';
import 'package:tyrecare/models.dart';

void main() {
  const pneumatico = Pneumatico(
    posizione: 'antSx',
    pressioneBase: 2.4,
    usuraBase: 90,
    temperatura: 28,
    battistradaMm: 6.2,
  );

  test('keeps certified tyre values independent from client-side simulations', () {
    expect(pneumatico.calcolaUsuraDinamica(0), 90);
    expect(pneumatico.calcolaUsuraDinamica(1500), 90);
    expect(pneumatico.calcolaUsuraDinamica(20000), 90);
  });

  test('uses certified vehicle mileage and average tyre state', () {
    const vehicle = Veicolo(
      nome: 'Test car',
      anno: '2024',
      chilometriIniziali: '1000',
      immagineUrl: '',
      antSx: pneumatico,
      antDx: pneumatico,
      postSx: pneumatico,
      postDx: pneumatico,
    );

    expect(vehicle.chilometriTotali(250.9), 1000);
    expect(vehicle.mediaUsuraGenerale(1500), 90);
  });
}
