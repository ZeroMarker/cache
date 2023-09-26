Class web.DHCENS.STBLL.RIS.MODEL.OrderItemID Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OrderItemID";

/// 医嘱明细ID
Property OEORIOrderItemID As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrderItemID");

/// 医嘱执行科室代码
Property OEORIExecDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "OEORIExecDeptCode");

/// 医嘱执行科室名称
Property OEORIExecDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "OEORIExecDeptDesc");

/// 医嘱子类代码
Property OEORIOrdSubCatCode As %Library.String(MAXLEN = 50, XMLNAME = "OEORIOrdSubCatCode");

/// 医嘱子类描述
Property OEORIOrdSubCatDesc As %Library.String(MAXLEN = 50, XMLNAME = "OEORIOrdSubCatDesc");

}
