
// 保存参数值的object
var InitParamObj = GetAppPropValue('DHCSTTRANSFERM');
// 请求参数
var InRequestParamObj = GetAppPropValue('DHCSTINREQM');
// 物资信息维护参数
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
function DefaultStDate() {
	var Today = new Date();
	var DefaStartDate = InitParamObj.DefaStartDate;
	if (isEmpty(DefaStartDate)) {
		return DateFormatter(Today);
	}
	var StDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(StDate);
}

function DefaultEdDate() {
	var Today = new Date();
	var DefaEndDate = InitParamObj.DefaEndDate;
	if (isEmpty(DefaEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}

// 出库类型默认值
function GetInitTypeDefa() {
	var TYPE = 'OM';
	var IngrtypeInfo = tkMakeServerCall('web.DHCSTMHUI.Common.Dicts', 'GetDefaOPtype', TYPE, gHospId);
	return IngrtypeInfo;
}