var CleanParamObj = GetAppPropValue('CSSDCLEAN');
var MachineFtpObj = GetAppPropValue('CSSDMACHINEFTP');
function DefaultStDate() {
	var Today = new Date();
	var DefStartDate = CleanParamObj.DefStartDate;
	if (isEmpty(DefStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefStartDate));
	return DateFormatter(EdDate);
}
function DefaultEdDate() {
	var Today = new Date();
	var DefEndDate = CleanParamObj.DefEndDate;
	if (isEmpty(DefEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefEndDate));
	return DateFormatter(EdDate);
}
function DefaultBeforeDate() {
	var Today = new Date();
	var DefBeforeDate = -7;
	if (isEmpty(DefBeforeDate)) {
		return DateFormatter(Today);
	}
	var EdBeforeDate = DateAdd(Today, 'd', parseInt(DefBeforeDate));
	return DateFormatter(EdBeforeDate);
}