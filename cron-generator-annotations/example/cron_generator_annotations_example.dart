import 'package:cron_generator_annotations/cron_generator_annotations.dart';

part 'cron_generator_annotations_example.g.dart';

class MyCron = MyCronTest with _$MyCronCron;

@CronBase()
class MyCronTest {
  @CronGenMethod(minutes: '1-2')
  void myCronStuffs(int arg, {required int requiredArg, double? optionalArg}) {
    print('myMethodTestWithPositioneds original $arg requiredArg $requiredArg');
  }
}

Future<void> main() async {
  final cronObj = MyCron();
  cronObj.myCronStuffs(1, requiredArg: 2);

  await Future<void>.delayed(const Duration(minutes: 10));

  await cronObj.close();
}