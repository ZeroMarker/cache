Class web.DHCENS.STBLL.PIS.MODEL.Order Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Order";

/// 医嘱明细ID
Property OEORIOrderItemID As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrderItemID");

/// 检查部位代码
Property RISRPositionCode As %Library.String(MAXLEN = 3, XMLNAME = "RISRPositionCode");

/// 检查体位代码
Property RISRPostureCode As %Library.String(MAXLEN = 3, XMLNAME = "RISRPostureCode");

/// 检查代码
Property RISRCode As %Library.String(MAXLEN = 3, XMLNAME = "RISRCode");

/// 标本列表
Property Specimens As list Of web.DHCENS.STBLL.PIS.MODEL.Specimen(XMLNAME = "Specimen", XMLPROJECTION = "ELEMENT");

}
