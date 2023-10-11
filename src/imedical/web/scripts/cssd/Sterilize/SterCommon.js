var SterParamObj = GetAppPropValue('CSSDSTERILIZE');
var MachineFtpObj = GetAppPropValue('CSSDMACHINEFTP');
// return:起始日期
function DefaultStDate() {
	var Today = new Date();
	var DefStartDate = SterParamObj.DefStartDate;
	if (isEmpty(DefStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefStartDate));
	return DateFormatter(EdDate);
}
function DefaultEdDate() {
	var Today = new Date();
	var DefEndDate = SterParamObj.DefEndDate;
	if (isEmpty(DefEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefEndDate));
	return DateFormatter(EdDate);
}