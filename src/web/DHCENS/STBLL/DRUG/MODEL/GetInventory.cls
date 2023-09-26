Class web.DHCENS.STBLL.DRUG.MODEL.GetInventory Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "GetInventor";

Property ResultCode As %Library.String(XMLNAME = "ResultCode");

Property ResultContent As %Library.String(XMLNAME = "ResultContent");

Property DepCode As %Library.String(XMLNAME = "DepCode");

Property DrugCode As %Library.String(XMLNAME = "DrugCode");

Property DrugName As %Library.String(XMLNAME = "DrugName");

Property Qty As %Library.String(XMLNAME = "Qty");

Property Unit As %Library.String(XMLNAME = "Unit");

}
