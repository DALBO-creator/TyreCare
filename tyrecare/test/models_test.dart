import 'package:flutter_test/flutter_test.dart';
import 'package:tyrecare/models.dart';

void main() {
  const tyre = Pneumatico(
    posizione: 'antSx',
    pressioneBase: 2.4,
    temperatura: 28,
    battistradaMm: 6.2,
    marca: 'Pirelli',
    modello: 'Cinturato All Season',
    misura: '225/45 R17',
    dot: '1424',
    condizione: TyreCondition.excellent,
  );

  test('stores the technical values certified by the workshop', () {
    expect(tyre.battistradaMm, 6.2);
    expect(tyre.pressioneBase, 2.4);
    expect(tyre.condizione, TyreCondition.excellent);
  });

  test('groups the four certified tyres on a vehicle', () {
    const vehicle = Veicolo(
      nome: 'Test car',
      anno: '2024',
      chilometraggio: 1000,
      antSx: tyre,
      antDx: tyre,
      postSx: tyre,
      postDx: tyre,
    );

    expect(vehicle.chilometraggio, 1000);
    expect(vehicle.pneumatici, hasLength(4));
    expect(vehicle.pneumatici.first.marca, 'Pirelli');
  });
}
