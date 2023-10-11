// /名称: 退货相关公共方法及变量
// /描述: 退货相关公共方法及变量
// /编写者：XuChao
// /编写日期: 2018.5.25

// 保存参数值的object
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
// 物资维护参数
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