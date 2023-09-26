Class web.DHCENS.STBLL.ORDER.MODEL.RespOrder Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OEORIInfo";

Property HISOEORIOrderItemID As %Library.String(XMLNAME = "HISOEORIOrderItemID");

Property OEORIOrderItemID As %Library.String(XMLNAME = "OEORIOrderItemID");

/// 处方号
Property PrescNo As %Library.String(XMLNAME = "PrescNo");

/// 医嘱项ID
Property ARCItmMastID As %Library.String(XMLNAME = "ARCItmMastID");

/// 价格
Property Price As %Library.String(XMLNAME = "Price");

}
