functions = require('./aggregate').functions

histogram = (rows, valueField) ->
  ###
  Given an array of rows like:
  
      {histogram} = require('../')
  
      rows = [
        {age:  7},
        {age: 25},
        {age: 23},
        {age: 27},
        {age: 34},
        {age: 55},
        {age: 42},
        {age: 13},
        {age: 11},
        {age: 23},
        {age: 31},
        {age: 32},
        {age: 29},
        {age: 16},
        {age: 31},
        {age: 22},
        {age: 25},
      ]
      
  histogram will calculate a histogram. There will be sqrt(n) + 1 buckets
  
      {buckets, chartMax} = histogram(rows, 'age')
      for b in buckets
        console.log(b.label, b.count)
      # 0-13 2
      # 13-26 7
      # 26-39 6
      # 39-52 1
      # 52-65 1
      
      console.log(chartMax)
      # 65
  
  This histogram calculator will also attempt to lump outliers into a single bucket at the top.
      
      rows.push({age: 85})
  
      {buckets, chartMax} = histogram(rows, 'age')
  
      lastBucket = buckets[buckets.length - 1]
      console.log(lastBucket.label, lastBucket.count)
      # 68-86* 1
      
  The asterix `*` is there to indicate that this bucket is not the same size as the others and non-linear.
  The histogram calculator will also "clip" the values for these outliers so that you can
  display them in a scatter chart on a linear scale with the last band compressed. 
  The `clippedChartValue` will be guaranteed to be below the `chartMax` by interpolating it's position between
  the bounds of the top band where the actual max value is scaled down to the `chartMax`
  
      lastBucket = buckets[buckets.length - 1]
      console.log(lastBucket.rows[0].age, lastBucket.rows[0].clippedChartValue)
      # 85 84.05555555555556
            
  ###
  chartValues = (row[valueField] for row in rows)
  
  average = functions.$average(chartValues)
  standardDeviation = functions.$standardDeviation(chartValues)
  upperBound = average + 2 * standardDeviation
  
  chartValuesMinusOutliers = (c for c in chartValues when c < upperBound)
  
  bucketCount = Math.floor(Math.sqrt(chartValuesMinusOutliers.length))
  
  if bucketCount < 3
    return undefined  # !TODO: Decide how to handle this
  
  bucketSize = Math.floor(upperBound / bucketCount) + 1
  
  upperBound = bucketSize * bucketCount
  
  chartMin = 0
  chartMax = upperBound + bucketSize  # This will be at the very top of the top bucket
  
  valueMax = Math.floor(functions.$max(chartValues)) + 1
  valueMax = Math.max(chartMax, valueMax)
  
  # add clippedChartValues to timeInState
  # the clippedChartValue is interpolated between upperBound and valueMax to fit within one bucketSize
  for row in rows
    if row[valueField] >= upperBound
      row.clippedChartValue = upperBound + bucketSize * (row[valueField] - upperBound) / (valueMax - upperBound)
    else
      row.clippedChartValue = row[valueField]
    
  buckets = []
  for i in [0..bucketCount]
    bucket = {
      label: "#{Math.floor(i * bucketSize)}-#{Math.floor((i + 1) * bucketSize)}", 
      rows: []
      count: 0
    }
    buckets.push(bucket)
  
  clipped = not (valueMax == chartMax)
  if clipped
    buckets[bucketCount].label = "#{upperBound}-#{valueMax}*"
  else
    buckets[bucketCount].label = "#{upperBound}-#{valueMax}"
  
  total = 0
  for row in rows
    if row[valueField] >= upperBound
      bucket = buckets[buckets.length - 1]
    else
      bucket = buckets[Math.floor(row[valueField] / bucketSize)]
    bucket.rows.push(row)
    bucket.count++
    total++
  
  percentile = 0
  for b in buckets
    percentile += b.count / total
    b.percentile = percentile
  buckets[buckets.length - 1].percentile = 1.0
    
  return {buckets, bucketSize, chartMax, clipped, valueMax}
    
exports.histogram = histogram
