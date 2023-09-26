Class web.DHCSTMService.Lis.Model.OrderDetail Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property MATERIALID As %String(MAXLEN = "", XMLNAME = "MATERIALID");

Property QUANTITY As %String(MAXLEN = "", XMLNAME = "QUANTITY");

Property SUBPACKNO As %String(MAXLEN = "", XMLNAME = "SUBPACKNO");

Property SUPPLIERID As %String(MAXLEN = "", XMLNAME = "SUPPLIERID");

Property REMARK As %String(MAXLEN = "", XMLNAME = "REMARK");

}
