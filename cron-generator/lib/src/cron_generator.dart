import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:cron_generator_annotations/cron_generator_annotations.dart';
import 'package:source_gen/source_gen.dart';

const _checker = TypeChecker.fromRuntime(CronGenMethod);

const _futuresTypes = ['Future<void>', 'FutureOr<void>'];
class CronGenerator extends GeneratorForAnnotation<CronBase> {

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element.kind != ElementKind.CLASS || element is! ClassElement) {
      throw Exception('Cron class must be annotated in a class');
    }

    if (element.isFinal ||
        element.isInterface ||
        element.isMixinClass ) {
      throw Exception('Class cannot be used');
    }
    final buffer = StringBuffer()
      ..writeln('mixin _\$${element.name}Cron on ${element.name} {\n')
      ..writeln('final _cron = Cron();');

    for (final child in element.children) {
      if (child is MethodElement && (
          child.returnType is VoidType ||
          _futuresTypes.contains(child.returnType.toString())
      )) {
        final cronMethod = child.metadata
          .firstWhereOrNull((element) =>
            element.element?.displayName == 'CronGenMethod' ||
            element.element?.displayName == 'CronGenMethod.parse',
          );
        if (cronMethod != null) {
          final scheduler = getSchedulerNamed(child);
          final methodOverwrite = writeMethod(child, scheduler);
          buffer.write(methodOverwrite);
        }
      }
    }
    buffer
      ..writeln('  Future close() => _cron.close();')
      ..writeln('}');

    return buffer.toString();
  }

  String getSchedulerNamed(Element cronMethod) {
    if (_checker
        .firstAnnotationOfExact(cronMethod)
        ?.getField('data')
        ?.toStringValue() case final String obj) {
      return "Schedule.parse('$obj')";
    }
    final fields = ['seconds', 'minutes', 'hours', 'days', 'months', 'weekdays'];
    final args = <String>[];
    for (final field in fields) {
      final obj = _checker
        .firstAnnotationOfExact(cronMethod)
        ?.getField(field);

      if (obj == null || obj.isNull) continue;
      args.add('$field: ${getDataArgument(obj)}');
    }
    return 'Schedule(${args.join(', ')})';
  }

  String getDataArgument(DartObject obj) => switch(obj.type.toString()) {
    'String' => "'${obj.toStringValue()}'",
    'int' => '${obj.toIntValue()}',
    'List<int>' => obj.toListValue()
      ?.map((e) => e.toIntValue())
      .toList()
      .toString() ?? '',
    _ => throw Exception('Type not allowed, this field only accepts String, int and List<int>')
  };

  String writeMethod(MethodElement child, String arg) {
    final buffer = StringBuffer()
      ..writeln('  @override')
      ..writeln('  ${child.declaration} ')
      ..writeAll([
        if (_futuresTypes.contains(child.returnType.toString()))
          (' async '),
        ' {\n',
      ]);

    final methodArgs = <String>[];
    for (final child in child.children) {
      if (child is ParameterElement) {
        if (child.isPositional || child.isOptionalPositional) {
          methodArgs.add(child.name);
        } else if (child.isNamed) {
          methodArgs.add('${child.name}: ${child.name}');
        }
      }
    }
    final superCall = 'super.${child.name}(${methodArgs.join(', ')})';
    buffer
      ..writeln('    _cron.schedule($arg, () => $superCall);')
      ..writeln('  }');
    return buffer.toString();
  }
}
