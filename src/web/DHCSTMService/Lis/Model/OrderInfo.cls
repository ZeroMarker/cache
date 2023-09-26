Class web.DHCSTMService.Lis.Model.OrderInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property ORDERNO As %String(MAXLEN = "", XMLNAME = "ORDERNO");

Property CHECKDATE As %String(MAXLEN = "", XMLNAME = "CHECKDATE");

Property REAGENTGROUPID As %String(MAXLEN = "", XMLNAME = "REAGENTGROUPID");

Property DEPARTMENTID As %String(MAXLEN = "", XMLNAME = "DEPARTMENTID");

Property CREATORID As %String(MAXLEN = "", XMLNAME = "CREATORID");

Property OrderDetailList As list Of web.DHCSTMService.Lis.Model.OrderDetailList(XMLNAME = "OrderDetailList", XMLPROJECTION = "ELEMENT");

}
