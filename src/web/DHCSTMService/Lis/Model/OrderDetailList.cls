Class web.DHCSTMService.Lis.Model.OrderDetailList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property OrderDetail As list Of web.DHCSTMService.Lis.Model.OrderDetail(XMLNAME = "OrderDetail", XMLPROJECTION = "ELEMENT");

}
