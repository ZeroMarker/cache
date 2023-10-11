var CallBackParamObj = GetAppPropValue('CSSDCALLBACK');
var ApplyParamObj = GetAppPropValue('CSSDAPPLAY');
// return:起始日期
function DefaultStDate() {
	var Today = new Date();
	var DefStartDate = CallBackParamObj.DefStartDate;
	if (isEmpty(DefStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefStartDate));
	return DateFormatter(EdDate);
}
function DefaultEdDate() {
	var Today = new Date();
	var DefEndDate = CallBackParamObj.DefEndDate;
	if (isEmpty(DefEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefEndDate));
	return DateFormatter(EdDate);
}
// 设置一周前的日期
function DefaultBeforeDate() {
	var Today = new Date();
	var DefBeforeDate = -7;
	if (isEmpty(DefBeforeDate)) {
		return DateFormatter(Today);
	}
	var EdBeforeDate = DateAdd(Today, 'd', parseInt(DefBeforeDate));
	return DateFormatter(EdBeforeDate);
}