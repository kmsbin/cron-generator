import 'package:meta/meta_meta.dart';

export 'package:cron/cron.dart';

@Target({TargetKind.classType})
class CronBase {
  const CronBase();

  factory CronBase.parse() => const CronBase();
}

@Target({TargetKind.method})
class CronGenMethod {
  final dynamic seconds;
  final dynamic minutes;
  final dynamic hours;
  final dynamic days;
  final dynamic months;
  final dynamic weekdays;
  final String? data;

  const CronGenMethod({
    this.seconds,
    this.minutes,
    this.hours,
    this.days,
    this.months,
    this.weekdays,
  }) : data = null;

  const CronGenMethod.parse(this.data) :
        seconds = null,
        minutes = null,
        hours = null,
        days = null,
        months = null,
        weekdays = null;
}
