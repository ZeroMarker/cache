
// �������ֵ��object
var InitParamObj = GetAppPropValue('DHCSTTRANSFERM');
// �������
var InRequestParamObj = GetAppPropValue('DHCSTINREQM');
// ������Ϣά������
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

// ��������Ĭ��ֵ
function GetInitTypeDefa() {
	var TYPE = 'OM';
	var IngrtypeInfo = tkMakeServerCall('web.DHCSTMHUI.Common.Dicts', 'GetDefaOPtype', TYPE, gHospId);
	return IngrtypeInfo;
}