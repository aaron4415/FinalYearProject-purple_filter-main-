// /// TO DO: Maybe change to just moving? Copy from test_reset_progress
// listener = sensor.gyroscopeEvents.listen( (GyroscopeEvent event) {
// double combinedXYZ = event.z * event.z + event.y * event.y + event.x * event.x;
// final gyroscopeFilter = SimpleKalman(errorMeasure: 512, errorEstimate: 120, q: 0.5);
// double gyroscopeData = gyroscopeFilter.filtered(combinedXYZ);
// gyroscopeData = gyroscopeData < 0.0005 ? 0 : gyroscopeData;
// filteredGyroscope.add(gyroscopeData);
// if (filteredGyroscope.length > 300) filteredGyroscope.removeAt(0);
//
// List<double> sublistOfFilteredGyroscope =
// filteredGyroscope.length > 100 ?
// filteredGyroscope.sublist(filteredGyroscope.length-100,
// filteredGyroscope.length-1) : filteredGyroscope;
// int nonZeroCount = 0;
// for (double element in sublistOfFilteredGyroscope) {
// if (element != 0 ) nonZeroCount++;
// }
// nonZeroGyroscopeDataPercentage = nonZeroCount / 100; //threshold > 0.05 (5%)
// nonZeroCount = 0;
// setState(() {
// isDeviceMoving = nonZeroGyroscopeDataPercentage > 0.20 ? true : false;
// actualDistance;
// });
// });