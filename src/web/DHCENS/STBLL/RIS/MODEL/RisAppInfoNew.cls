Class web.DHCENS.STBLL.RIS.MODEL.RisAppInfoNew Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "AddRisAppBillRt";

/// 检查申请单信息
Property OrderList As list Of web.DHCENS.STBLL.RIS.MODEL.OrderList(XMLPROJECTION = "ELEMENT");

}
