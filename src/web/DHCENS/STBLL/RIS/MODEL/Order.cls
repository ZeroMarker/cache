Class web.DHCENS.STBLL.RIS.MODEL.Order Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Order";

/// 医嘱明细ID
Property OEORIOrderItemID As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrderItemID");

/// 检查部位代码
Property RISRPositionCode As %Library.String(MAXLEN = 30, XMLNAME = "RISRPositionCode");

/// 检查体位代码
Property RISRPostureCode As %Library.String(MAXLEN = 30, XMLNAME = "RISRPostureCode");

/// 检查代码
Property RISRCode As %Library.String(MAXLEN = 30, XMLNAME = "RISRCode");

/// 检查描述
Property RISRDesc As %Library.String(MAXLEN = 50, XMLNAME = "RISRDesc");

/// 医嘱价格 
Property RISRPrice As %Library.String(MAXLEN = 50, XMLNAME = "RISRPrice");

}
