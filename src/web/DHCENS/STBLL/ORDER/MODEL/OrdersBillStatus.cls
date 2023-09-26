Class web.DHCENS.STBLL.ORDER.MODEL.OrdersBillStatus Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "OEORIInfo";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医嘱明细ID
Property OEORIOrderItemID As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrderItemID");

/// 医嘱计费状态代码
Property OEORIBillStatusCode As %Library.String(MAXLEN = 30, XMLNAME = "OEORIBillStatusCode");

/// 医嘱计费状态描述
Property OEORIBillStatusDesc As %Library.String(MAXLEN = 30, XMLNAME = "OEORIBillStatusDesc");

/// 退费原因
Property ReturnReason As %Library.String(MAXLEN = 30, XMLNAME = "ReturnReason");

/// 医嘱子类代码
Property OEORIOrdSubCatCode As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrdSubCatCode");

/// 医嘱子类描述
Property OEORIOrdSubCatDesc As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrdSubCatDesc");

/// 医嘱大类代码
Property OEORIOrdCatCode As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrdCatCode");

/// 医嘱大类描述
Property OEORIOrdCatDesc As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrdCatDesc");

/// 接收科室代码
Property OEORIAcceptDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "OEORIAcceptDeptCode");

/// 申请科室代码
Property OEORIAppDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "OEORIAppDeptCode");

}
