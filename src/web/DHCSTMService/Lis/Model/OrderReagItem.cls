Class web.DHCSTMService.Lis.Model.OrderReagItem Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property MaterialCode As %String(MAXLEN = "", XMLNAME = "MaterialCode");

Property MaterialName As %String(XMLNAME = "MaterialName");

Property MaterialSpec As %String(MAXLEN = "", XMLNAME = "MaterialSpec");

Property MaterialUnit As %String(MAXLEN = "", XMLNAME = "MaterialUnit");

Property MaterialQty As %String(XMLNAME = "MaterialQty");

Property BatchNum As %String(MAXLEN = "", XMLNAME = "BatchNum");

}
