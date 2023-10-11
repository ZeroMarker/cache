// /名称:采购计划相关公共方法及变量
// /描述:采购计划相关公共方法及变量
// /编写者:lxt
// /编写日期:2018-5-10

// 保存参数值的object
var InPurPlanParamObj = GetAppPropValue('DHCSTPURPLANAUDITM');
var InPoParamObj = GetAppPropValue('DHCSTPOM');		// 涉及到订单相关处理参数
// 物资维护参数
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
// 科室类型全局变量
var INPURPLAN_LOCTYPE = 'Login';
// 下拉框参数
var PurLocParams = JSON.stringify(addSessionParams({ Type: INPURPLAN_LOCTYPE }));
var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
// /return:起始日期
function DefaultStDate() {
	var Today = new Date();
	var DefaStartDate = InPurPlanParamObj.DefaStartDate;
	if (isEmpty(DefaStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(EdDate);
}
function DefaultEdDate() {
	var Today = new Date();
	var DefaEndDate = InPurPlanParamObj.DefaEndDate;
	if (isEmpty(DefaEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}