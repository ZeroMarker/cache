// /����:		���������ع�������������
// /����:		���������ع�������������
// /��д��:	XuChao
// /��д����:	2018-05-8
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
// �������ֵ��object
var InRequestParamObj = GetAppPropValue('DHCSTINREQM');
// ת�Ƶ�����
var InitParamObj = GetAppPropValue('DHCSTTRANSFERM');
// ����ά������
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
var SupLocParamsObj = {};		// ��Ӧ������

// ��������ȫ�ֱ���
var INREQUEST_LOCTYPE = '';
if (InRequestParamObj && InRequestParamObj.ReqLocUseLinkLoc) {
	INREQUEST_LOCTYPE = InRequestParamObj.ReqLocUseLinkLoc == 'Y' ? 'LinkLoc' : 'Login';
}
// /return:��ʼ����
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