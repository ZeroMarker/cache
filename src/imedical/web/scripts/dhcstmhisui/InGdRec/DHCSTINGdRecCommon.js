// /名称: 入库相关公共方法及变量
// /描述: 入库相关公共方法及变量
// /编写者：lihui
// /编写日期: 20180521

// 保存参数值的object
var IngrParamObj = GetAppPropValue('DHCSTIMPORTM');
var SessionParams = gGroupId + '^' + gLocId + '^' + gUserId + '^' + gHospId;
var ItmTrackParamObj = GetAppPropValue('DHCITMTRACKM');
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
/*
 * creator:zhangdongmei,2012-09-26
 * description:验证发票号是否存在于别的入库单
 * params: invNo:发票号,ingr:入库主表id
 * return: true:不存在,发票号有效；false:存在,发票号无效
 * */
function InvNoValidator(invNo, ingr, invCode) {
	if (isEmpty(IngrParamObj)) {
		return true;
	}
	if (isEmpty(invNo)) {
		return true;
	}
	if (IngrParamObj.CheckInvNo != 'Y') {
		return true;
	}
	var Flag = true;
	var InvnoExistFlag = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckInvnoExist', ingr, invNo, invCode);
	
	if (InvnoExistFlag == 1) {
		Flag = false; // 该发票号已存在于别的入库单
	}
	return Flag;
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:验证效期是否需要提示
 * params: expDate:效期，ARG_DATEFORMAT
 * return: true:效期合理，不需要提示；false:效期不合理，需要提示
 * */
function ExpDateValidator(expDate, Inci) {
	if (isEmpty(expDate)) {
		return '';
	}
	var ExpChcekInfo = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckExpDate', Inci, expDate);
	if (ExpChcekInfo != '') {
		return ExpChcekInfo;
	}
	return '';
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:取默认的起始日期
 * params: 
 * return:起始日期
 * */
function DefaultStDate() {
	var Today = new Date();
	var DefaStartDate = IngrParamObj.DefaStartDate;
	if (isEmpty(DefaStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(EdDate);
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:取默认的截止日期
 * params: 
 * return:截止日期
 * */
function DefaultEdDate() {
	var Today = new Date();
	var DefaEndDate = IngrParamObj.DefaEndDate;
	if (isEmpty(DefaEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}

// 入库类型默认值
function GetIngrtypeDefa() {
	var TYPE = 'IM';
	var IngrtypeInfo = tkMakeServerCall('web.DHCSTMHUI.Common.Dicts', 'GetDefaOPtype', TYPE, gHospId);
	return IngrtypeInfo;
}
function GetPurUserDefa(LocId) {
	var PurUserInfo = tkMakeServerCall('web.DHCSTMHUI.Common.Dicts', 'GetDefaPurUser', LocId);
	return PurUserInfo;
}