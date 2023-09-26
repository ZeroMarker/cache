Class web.DHCSTMService.Lis.Model.OrderReag Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

// Property RGOrderInfo As %String(XMLNAME = "RGOrderInfo");

// Property SourceSystem As %String(XMLNAME = "SourceSystem");

// Property MessageID As %String(XMLNAME = "MessageID");

// Property ResultCode As %String;

// Property ResultContent As %String;

Property OrderListNo As %String(MAXLEN = "", XMLNAME = "OrderListNo");

Property CTMASupplier As %String(MAXLEN = "", XMLNAME = "CTMASupplier");

Property DepCode As %String(MAXLEN = "", XMLNAME = "DepCode");

Property DepDesc As %String(MAXLEN = "", XMLNAME = "DepDesc");

Property UserDesc As %String(MAXLEN = "", XMLNAME = "UserDesc");

Property Remarks As %String(MAXLEN = "", XMLNAME = "Remarks");

Property OrderReagItemsList As list Of web.DHCSTMService.Lis.Model.OrderReagItmList(XMLNAME = "OrderReagItemsList", XMLPROJECTION = "ELEMENT");

}
