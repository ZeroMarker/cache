// /名称:		库存请求相关公共方法及变量
// /描述:		库存请求相关公共方法及变量
// /编写者:	XuChao
// /编写日期:	2018-05-8
/*
DefaEndDate:"0"
DefaStartDate:"-10"
IfAllowReqBQtyUsed:"N"
IfRequestMoreThanStock:"Y"
IndirPrint:"Y"
IsRequestNoStock:"Y"
IsSplit:"N"
NoScgLimit:"N"
PrintNoComplete:"Y"
ProvLocAuditRequired:"Y"
QtyFlag:"Y"
RecLocAuditRequired:"Y"
ReqLocUseLinkLoc:"N"
ReqLocifuseLikeLoc:"N"
SetReserverdQty:"N"
*/
// 保存参数值的object
var InRequestParamObj = GetAppPropValue('DHCSTINREQM');
// 转移单参数
var InitParamObj = GetAppPropValue('DHCSTTRANSFERM');
// 物资维护参数
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
var SupLocParamsObj = {};		// 供应方参数

// 科室类型全局变量
var INREQUEST_LOCTYPE = '';
if (InRequestParamObj && InRequestParamObj.ReqLocUseLinkLoc) {
	INREQUEST_LOCTYPE = InRequestParamObj.ReqLocUseLinkLoc == 'Y' ? 'LinkLoc' : 'Login';
}
// /return:起始日期
function DefaultStDate() {
	var Today = new Date();
	var DefaStartDate = InRequestParamObj.DefaStartDate;
	if (isEmpty(DefaStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(EdDate);
}
function DefaultEdDate() {
	var Today = new Date();
	var DefaEndDate = InRequestParamObj.DefaEndDate;
	if (isEmpty(DefaEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}