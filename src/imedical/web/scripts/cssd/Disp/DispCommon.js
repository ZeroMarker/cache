var DispParamObj = GetAppPropValue('CSSDDISP');
// return:起始日期
function DefaultStDate() {
	var Today = new Date();
	var DefStartDate = DispParamObj.DefStartDate;
	if (isEmpty(DefStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefStartDate));
	return DateFormatter(EdDate);
}
function DefaultEdDate() {
	var Today = new Date();
	var DefEndDate = DispParamObj.DefEndDate;
	if (isEmpty(DefEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefEndDate));
	return DateFormatter(EdDate);
}