// /����: �˻���ع�������������
// /����: �˻���ع�������������
// /��д�ߣ�XuChao
// /��д����: 2018.5.25

// �������ֵ��object
/**
DefStartDate: "-30",
DefEndDate: "0",
//AllowModifyRp: "N",
//AllowModifySp: "N",
AllowReturnElse:"N"
AllowSaveReasonEmpty:"N"
AutoAuditAfterCompDRET:"N"
AutoCompAfterSaveDRET:"N"
AutoPrintAfterAuditDRET:"N"
AutoPrintAfterSaveDRET:"Y"
CreateInitByIngRet:"N"
DefaRetReason:"Y"
IndirPrint:"Y"
PrintNegative:"Y"
PrintNum:"2"
 */
var IngrtParamObj = GetAppPropValue('DHCSTRETURNM');
// ����ά������
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
function DefaultStDate() {
	var Today = new Date();
	var DefStartDate = IngrtParamObj.DefStartDate;
	if (isEmpty(DefStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefStartDate));
	return DateFormatter(EdDate);
}

function DefaultEdDate() {
	var Today = new Date();
	var DefEndDate = IngrtParamObj.DefEndDate;
	if (isEmpty(DefEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefEndDate));
	return DateFormatter(EdDate);
}