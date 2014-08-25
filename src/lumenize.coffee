# Define exports for the lumenize requirejs module
define 'lumenize', [
	'Time'
	'Timeline'
	'utils'
	'iCalculator'
	'TimeInStateCalculator'
	'TransitionsCalculator'
	'TimeSeriesCalculator'
	'dataTransform'
	'functions'
	'histogram'
	'multiRegression'
	'table'
	'OLAPCube'
	'anova'
	'distributions'
	'DataFlow'
	'Classifier'
], (
	Time
	Timeline
	utils
	iCalculator
	TimeInStateCalculator
	TransitionsCalculator
	TimeSeriesCalculator
	dataTransform
	functions
	histogram
	multiRegression
	table
	OLAPCube
	anova
	distributions
	DataFlow
	Classifier
	) ->

	exports=
		Time: Time
		Timeline: Timeline.Timeline
		TimelineIterator: Timeline.TimelineIterator
		utils: utils
		iCalculator: iCalculator
		TimeInStateCalculator: TimeInStateCalculator
		TransitionsCalculator: TransitionsCalculator
		TimeSeriesCalculator: TimeSeriesCalculator
		arrayOfMaps_To_CSVStyleArray: dataTransform.arrayOfMaps_To_CSVStyleArray
		csvStyleArray_To_ArrayOfMaps: dataTransform.csvStyleArray_To_ArrayOfMaps
		arrayOfMaps_To_HighChartsSeries: dataTransform.arrayOfMaps_To_HighChartsSeries
		csvString_To_CSVStyleArray: dataTransform.csvString_To_CSVStyleArray
		csvStyleArray_To_CSVString: dataTransform.csvStyleArray_To_CSVString
		functions: functions
		histogram: histogram
		multiRegression: multiRegression
		table: table
		OLAPCube: OLAPCube
		anova: anova
		distributions: distributions
		DataFlow: DataFlow
		Classifier: Classifier.Classifier
		BayesianClassifier: Classifier.BayesianClassifier
