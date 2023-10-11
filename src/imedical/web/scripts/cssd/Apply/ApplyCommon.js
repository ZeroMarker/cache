var ApplyParamObj = GetAppPropValue('CSSDAPPLAY');

function DefaultStDate() {
	var Today = new Date();
	var DefStartDate = ApplyParamObj.DefStartDate;
	if (isEmpty(DefStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefStartDate));
	return DateFormatter(EdDate);
}
function DefaultEdDate() {
	var Today = new Date();
	var DefEndDate = ApplyParamObj.DefEndDate;
	if (isEmpty(DefEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefEndDate));
	return DateFormatter(EdDate);
}