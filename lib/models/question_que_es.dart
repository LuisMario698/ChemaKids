class QuestionQueEs {
  final String imageUrl;
  final String correctAnswer;
  final String wrongAnswer;

  const QuestionQueEs({
    required this.imageUrl,
    required this.correctAnswer,
    required this.wrongAnswer,
  });
}

const List<QuestionQueEs> questions = [
  QuestionQueEs(
    imageUrl: 'https://raw.githubusercontent.com/kubilayckmk/puppilot/main/assets/car_3d.png',
    correctAnswer: 'Carro',
    wrongAnswer: 'Perro',
  ),
  QuestionQueEs(
    imageUrl: 'https://raw.githubusercontent.com/kubilayckmk/puppilot/main/assets/cat_3d.png',
    correctAnswer: 'Gato',
    wrongAnswer: 'León',
  ),
  QuestionQueEs(
    imageUrl: 'https://raw.githubusercontent.com/kubilayckmk/puppilot/main/assets/ball_3d.png',
    correctAnswer: 'Pelota',
    wrongAnswer: 'Manzana',
  ),
  QuestionQueEs(
    imageUrl: 'https://raw.githubusercontent.com/kubilayckmk/puppilot/main/assets/bird_3d.png',
    correctAnswer: 'Pájaro',
    wrongAnswer: 'Avión',
  ),
  QuestionQueEs(
    imageUrl: 'https://raw.githubusercontent.com/kubilayckmk/puppilot/main/assets/dog_3d.png',
    correctAnswer: 'Perro',
    wrongAnswer: 'Gato',
  ),
  QuestionQueEs(
    imageUrl: 'https://img.freepik.com/premium-vector/sun-cute-cartoon-vector-illustration_480744-401.jpg',
    correctAnswer: 'Sol',
    wrongAnswer: 'Luna',
  ),
  QuestionQueEs(
    imageUrl: 'https://img.freepik.com/premium-vector/tree-cute-cartoon-vector-illustration_480744-402.jpg',
    correctAnswer: 'Árbol',
    wrongAnswer: 'Flor',
  ),
  QuestionQueEs(
    imageUrl: 'https://img.freepik.com/premium-vector/book-cute-cartoon-vector-illustration_480744-403.jpg',
    correctAnswer: 'Libro',
    wrongAnswer: 'Cuaderno',
  ),
  QuestionQueEs(
    imageUrl: 'https://img.freepik.com/premium-vector/fish-cute-cartoon-vector-illustration_480744-404.jpg',
    correctAnswer: 'Pez',
    wrongAnswer: 'Pájaro',
  ),
  QuestionQueEs(
    imageUrl: 'https://img.freepik.com/premium-vector/banana-cute-cartoon-vector-illustration_480744-405.jpg',
    correctAnswer: 'Plátano',
    wrongAnswer: 'Manzana',
  ),
  QuestionQueEs(
    imageUrl: 'https://img.freepik.com/premium-vector/apple-cute-cartoon-vector-illustration_480744-406.jpg',
    correctAnswer: 'Manzana',
    wrongAnswer: 'Pera',
  ),
  QuestionQueEs(
    imageUrl: 'https://img.freepik.com/premium-vector/flower-cute-cartoon-vector-illustration_480744-407.jpg',
    correctAnswer: 'Flor',
    wrongAnswer: 'Árbol',
  ),
];
