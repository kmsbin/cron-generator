// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lint_a, lint_b

part of 'cron_generator_annotations_example.dart';

// **************************************************************************
// CronGenerator
// **************************************************************************

mixin _$MyCronCron on MyCronTest {
  final _cron = Cron();
  @override
  void myCronStuffs(int arg, {required int requiredArg, double? optionalArg}) {
    _cron.schedule(
        Schedule(minutes: '1-2'),
        () => super.myCronStuffs(arg,
            requiredArg: requiredArg, optionalArg: optionalArg));
  }

  Future close() => _cron.close();
}
