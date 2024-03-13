This package encapsulate your methods with cron jobs, using
[dart cron package](https://pub.dev/packages/cron) and is a source_gen study case so use with caught

## Usage

Add the @CronBase() annotation to your class and @CronGenMethod to the 
method that you desire to execute as a cron job.
```dart 
final CronStuff = CronStuffBase with _$CronStuffBaseCron; 

@CronBase()
class CronStuffBase {
  @CronGenMethod.parse('*/1 * * * *') /// will run at every minute
  void myCronStuffs(int arg, {required int requiredArg, double? optionalArg}) {
    print('myMethodTestWithPositioneds original $arg requiredArg $requiredArg');
  }  
}

```
Then you can use like this
```dart
final cronObj = CronStuff();

// execute cron 
cronObj.myCronStuffs(12, requiredArg: 2);
```

## Additional information

This package provides a wrapper for the [dart cron package](https://pub.dev/packages/cron). 
If you need documentation or have specific use cases for cron, it's recommended to use this package instead.