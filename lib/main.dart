import 'dart:io';
import 'dart:math';

import 'calculator.dart';

class Person {
  int age;
  String name;

  // Person(int age, String name) {
  //   this.age = age;
  //   this.name = name;
  // }
  Person(this.age, this.name);

  // Person.age(int age) {
  //   this.age = age;
  //   this.name = '손님';
  // }
  Person.age(int age) : this(age, '길동');

  void study() {
    print('$name study');
  }
}

class Spacecraft {
  String name;
  DateTime launchDate;

  // Constructor, with syntactic sugar for assignment to members.
  Spacecraft(this.name, this.launchDate) {
    // Initialization code goes here.
    name = name + '님';
  }

  // Named constructor that forwards to the default one.
  Spacecraft.unlaunched(String name) : this(name, null);

  // int get launchYear(){
  //   return launchDate?.year; // read-only non-final property
  // }

  int get launchYear => launchDate?.year; // read-only non-final property

  // Method.
  void describe() {
    print('Spacecraft: $name');
    if (launchDate != null) {
      int years = DateTime.now().difference(launchDate).inDays ~/ 365;
      print('Launched: $launchYear ($years years ago)');
    } else {
      print('Unlaunched');
    }
  }
}

class Orbiter extends Spacecraft {
  double altitude;
  Orbiter(String name, DateTime launchDate, this.altitude)
      : super(name, launchDate);

  @override
  void describe() {
    print("----자식----");
    super.describe();
    print("altitude:  ${altitude}");
  }
}

class Piloted {
  int astronauts = 1;
  //Mixins를 사용시 생성자 사용 못함
  void describeCrew() {
    print('Number of astronauts: $astronauts');
  }
}

class PilotedCraft extends Spacecraft with Piloted {
  PilotedCraft(String name, DateTime launchDate) : super(name, launchDate);
}

class MockSpaceship implements Spacecraft {
  @override
  DateTime launchDate;

  @override
  String name;

  MockSpaceship(this.launchDate, this.name);

  @override
  void describe() {
    // TODO: implement describe
  }

  @override
  // TODO: implement launchYear
  int get launchYear => throw UnimplementedError();
  // ···
}

abstract class Describable {
  void describe(); //구현체가 없음

  void describeWithEmphasis() {
    print('=========');
    describe();
    print('=========');
  }
}

class Unit extends Describable {
  @override
  void describe() {
    print('unit');
  }
}

class Animal implements Describable {
  @override
  void describe() {
    print('describe');
  }

  @override
  void describeWithEmphasis() {
    print('describeWithEmphasis');
  }
}

//Async 비동기
const oneSecond = Duration(seconds: 1);
Future<int> printWithDelay(String message) async {
  print('기다리는중..');
  await Future.delayed(oneSecond);
  print(message);
  return 1;
}

Future<void> printWithDelay2(String message) {
  return Future.delayed(oneSecond).then((_) {
    print(message);
  });
}

Future<void> createDescriptions(Iterable<String> objects) async {
  for (var object in objects) {
    try {
      var file = File('$object.txt');
      if (await file.exists()) {
        var modified = await file.lastModified();
        print('File for $object already exists. It was modified on $modified.');
        continue;
      }
      await file.create();
      await file.writeAsString('Start describing $object in this file.');
    } on IOException catch (e) {
      print('Cannot create description for $object: $e');
    }
  }
}

//stream
Stream<String> report(Spacecraft craft, Iterable<String> objects) async* {
  for (var object in objects) {
    await Future.delayed(oneSecond);
    yield '${craft.name} flies by $object'; // return 대신 yield로 반환
  }
}

void main() async {
  dataType();

  controlFlow();

  int result = fibonacci(5);
  print(result);

  lamda();

  int sum = add(1, 2);
  int multi = multiply(1, 2);
  print('더하기의 결과 : $sum, 곱하기의 결과 : $multi');

  //내장함수
  // Random random;

  //클래스
  Person person = Person(20, '철수');
  Person person2 = Person(21, '영희');
  person.study();
  person2.study();

  Person person3 = Person.age(23);
  person3.study();

  //Spacecraft
  Spacecraft spacecraft = Spacecraft('나루호', DateTime.now());
  // print('이름 : ${spacecraft.name}  발사일 : ${spacecraft.launchDate}');
  print(spacecraft.launchDate);
  spacecraft.describe();

  //상속
  Orbiter orbiter = Orbiter('상속나루호', DateTime.now(), 100);
  orbiter.describe();
  Spacecraft spacecraft5 = Orbiter('상속나루호', DateTime.now(), 100);
  spacecraft5.describe();

  //Mixins을 통한 다중 상속
  PilotedCraft pilotedCraft = PilotedCraft('홍길동', DateTime.now());
  pilotedCraft.describe();
  pilotedCraft.describeCrew();

  //다트에는 interface가 없음
  //implement를 통해서 메서드 재정의 가능
  MockSpaceship mockSpaceship = MockSpaceship(DateTime.now(), 'kim');
  print(mockSpaceship.name);

  //abstract 클래스
  Unit unit = Unit();
  unit.describe();
  unit.describeWithEmphasis();
  Animal animal = Animal();
  Animal animal2 = Animal();
  animal.describe();
  animal2.describe();
  animal.describeWithEmphasis();
  animal2.describeWithEmphasis();

  //Async
  int results = await printWithDelay('출력');
  print(results);

  //stream
  Spacecraft spacecrafts = Spacecraft('spaceraft', DateTime.now());
  Stream<String> resultStream = report(spacecrafts, ['abc', 'def', 'efg']);
  // await for (String s in resultStream) {
  //   print(s);
  // }
  resultStream.listen((s) {
    print(s);
  });
  print('코드종료');

  //exception - 동기든 비동기든 다 적용 됨
  var flybyObjects = ['abc', 'def'];
  try {
    for (var object in flybyObjects) {
      var description = await File('$object.txt').readAsString();
      print(description);
    }
  } on IOException catch (e) {
    print('Could not describe object: $e');
  } catch (e) {
    print('모든 error');
  } finally {
    flybyObjects.clear();
  }
}

void dataType() {
//bool - true or false
  bool visible = true;
  print(visible);

  //int
  int number = 17 ~/ 4; //나누기 (몫구하기)
  print(number);
  number = 17 % 4; //나머지 구하기
  print(number);

  //double
  double pi = 3.14 / 2; // 나누기
  print(pi);

  //string
  String name = 'lake';
  print(name);

  //list
  List ages = [10, 11, 12];
  print(ages[2]);

  //Map
  Map person = {'key': 'value'};
  print(person);

  //final (runtime에 값할당)
  final double pi2 = 3.14;
  final pi3 = 3.14;
  // pi2 = 3.15; //변경 불가
  print(pi2);
  print(pi3);

  //const (compile에 값할당 - 더 빠름)
  const pi4 = 3.14;
  // pi4 = 3.15; //변경 불가
  print(pi4);
}

//if문 for문 while문
void controlFlow() {
  bool b = true;
  if (!b || true) {
    print('good');
  } else {
    print('bad');
  }

  for (int i = 0; i <= 2; i++) {
    print(i);
  }

  List ages = [10, 11, 12];
  for (var age in ages) {
    print(age);
  }

  int year = 2014;
  while (year < 2016) {
    year += 1; // y++
    print(year);
  }
}

int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

void lamda() {
  List ages = [10, 11, 12];
  var fiteredAges = ages.where((age) => age > 10);
  print(fiteredAges);

  var p = print;
  fiteredAges.forEach(p); // 함수를 파라미터로 넘길수 있음

  List flybyObjects = ['abc', 'yourturn', 'imturn'];
  flybyObjects.where((name) => name.contains('turn')).forEach(print);

  String name = 'lake';
  print(name.contains('ke'));
}
