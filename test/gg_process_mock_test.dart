// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:convert';

import 'package:gg_process/gg_process.dart';
import 'package:test/test.dart';

void main() {
  group('GgProcessMock', () {
    test('should work fine', () async {
      // Create a new instance of GgProcessMock
      final process = GgProcessMock();

      // Create a new instance of GgProcessMock and pass the instance of
      // GgProcessMock to it
      final processWrapper = GgProcessWrapperMock(
        onStart: (_) => process,
      );

      // start the process
      final result = await processWrapper.start('executable', ['arg1', 'arg2']);
      expect(result, process);

      // Listen to the stdout and stderr streams, as well as the exitCode
      final stdouts = <String>[];
      result.stdout.map((event) => utf8.decode(event)).listen(stdouts.add);

      final stderrs = <String>[];
      result.stderr.map((event) => utf8.decode(event)).listen(stderrs.add);

      // Push some data to the stdout
      process.pushToStdout.add('stdout1');
      expect(stdouts, ['stdout1']);
      process.pushToStdout.add('stdout2');
      expect(stdouts, ['stdout1', 'stdout2']);

      // Push some data to the stderr
      process.pushToStderr.add('stderr1');
      expect(stderrs, ['stderr1']);
      process.pushToStderr.add('stderr2');
      expect(stderrs, ['stderr1', 'stderr2']);

      // Push the exitCode
      process.exit(5);
      final exitCode = await process.exitCode;
      expect(exitCode, 5);

      // Check if the stdout and stderr streams are closed
      expect(process.pushToStdout.isClosed, isTrue);
      expect(process.pushToStderr.isClosed, isTrue);

      // Should throw an UnimplementedError when stdin is called
      expect(() => result.stdin, throwsA(isA<UnimplementedError>()));

      // PID should be 0
      expect(result.pid, 0);

      // Kill the process
      final isNotNull = result.kill();
      expect(isNotNull, isTrue);

      expect(true, isNotNull);
    });
  });
}
