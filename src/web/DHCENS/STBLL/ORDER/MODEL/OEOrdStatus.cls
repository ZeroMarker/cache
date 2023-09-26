Class web.DHCENS.STBLL.ORDER.MODEL.OEOrdStatus Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "OEORIInfo";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医嘱明细ID
Property OEORIOrderItemID As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrderItemID");

/// 医嘱状态代码
Property OEORIStatusCode As %Library.String(MAXLEN = 10, XMLNAME = "OEORIStatusCode");

/// 医嘱子类代码
Property OEORIOrdSubCatCode As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrdSubCatCode");

/// 医嘱子类描述
Property OEORIOrdSubCatDesc As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrdSubCatDesc");

/// 医嘱大类代码
Property OEORIOrdCatCode As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrdCatCode");

/// 医嘱大类描述
Property OEORIOrdCatDesc As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrdCatDesc");

/// 父医嘱ID
Property OEORIParentOrderID As %Library.String(MAXLEN = 50, XMLNAME = "OEORIParentOrderID");

/// 医嘱开立科室代码
Property OEORIEnterDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "OEORIEnterDeptCode");

/// 医嘱开立科室
Property OEORIEnterDeptDesc As %Library.String(MAXLEN = 100, XMLNAME = "OEORIEnterDeptDesc");

/// 医嘱执行科室代码
Property OEORIExecDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "OEORIExecDeptCode");

/// 医嘱执行科室
Property OEORIExecDeptDesc As %Library.String(MAXLEN = 100, XMLNAME = "OEORIExecDeptDesc");

}
