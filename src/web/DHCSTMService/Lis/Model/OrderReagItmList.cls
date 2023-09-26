Class web.DHCSTMService.Lis.Model.OrderReagItmList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property OrderReagItem As list Of web.DHCSTMService.Lis.Model.OrderReagItem(XMLNAME = "OrderReagItem", XMLPROJECTION = "ELEMENT");

}
