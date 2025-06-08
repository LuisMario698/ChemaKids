class NumeroLetra {
  final String numero;
  final String numeroTexto;
  final String imageUrl;
  final List<String> palabrasRelacionadas;

  const NumeroLetra({
    required this.numero,
    required this.numeroTexto,
    required this.imageUrl,
    required this.palabrasRelacionadas,
  });
}

const List<NumeroLetra> numerosYLetras = [
  NumeroLetra(
    numero: '1',
    numeroTexto: 'UNO',
    imageUrl: 'https://img.freepik.com/premium-vector/one-cute-number-with-pencil-cartoon-vector-illustration_480744-386.jpg',
    palabrasRelacionadas: ['OSO', 'UÑA', 'UVA'],
  ),
  NumeroLetra(
    numero: '2',
    numeroTexto: 'DOS',
    imageUrl: 'https://img.freepik.com/premium-vector/two-cute-number-with-book-cartoon-vector-illustration_480744-387.jpg',
    palabrasRelacionadas: ['DEDO', 'DADO', 'DÍA'],
  ),
  NumeroLetra(
    numero: '3',
    numeroTexto: 'TRES',
    imageUrl: 'https://img.freepik.com/premium-vector/three-cute-number-with-ruler-cartoon-vector-illustration_480744-388.jpg',
    palabrasRelacionadas: ['TREN', 'TAZA', 'TORO'],
  ),
  NumeroLetra(
    numero: '4',
    numeroTexto: 'CUATRO',
    imageUrl: 'https://img.freepik.com/premium-vector/four-cute-number-with-backpack-cartoon-vector-illustration_480744-389.jpg',
    palabrasRelacionadas: ['CASA', 'CAMA', 'CAJA'],
  ),
  NumeroLetra(
    numero: '5',
    numeroTexto: 'CINCO',
    imageUrl: 'https://img.freepik.com/premium-vector/five-cute-number-with-apple-cartoon-vector-illustration_480744-390.jpg',
    palabrasRelacionadas: ['SOPA', 'SAPO', 'SOL'],
  ),
];
