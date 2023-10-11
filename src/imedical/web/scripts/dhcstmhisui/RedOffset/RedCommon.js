// /描述:  红冲相关公共方法及变量
// /编写者：wxj
// /编写日期: 20220912

// 保存参数值的object
var RedParamObj = GetAppPropValue('DHCSTMREDOFFSET');
var SessionParams = gGroupId + '^' + gLocId + '^' + gUserId + '^' + gHospId;
// 取默认的起始日期
function DefaultStDate() {
	var Today = new Date();
	var DefaStartDate = RedParamObj.DefaStartDate;
	if (isEmpty(DefaStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(EdDate);
}

// 取默认的截止日期
function DefaultEdDate() {
	var Today = new Date();
	var DefaEndDate = RedParamObj.DefaEndDate;
	if (isEmpty(DefaEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}