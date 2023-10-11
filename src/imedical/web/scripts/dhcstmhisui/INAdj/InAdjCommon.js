var InAdjParamObj = GetAppPropValue('DHCSTSTOCKADJM');
// /return:起始日期
function DefaultStDate() {
	var Today = new Date();
	var DefStartDate = InAdjParamObj.DefStartDate;
	if (isEmpty(DefStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefStartDate));
	return DateFormatter(EdDate);
}
function DefaultEdDate() {
	var Today = new Date();
	var DefEndDate = InAdjParamObj.DefEndDate;
	if (isEmpty(DefEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefEndDate));
	return DateFormatter(EdDate);
}