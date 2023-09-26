Class web.DHCSTMService.Lis.Model.BaseData Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "ListBaseData";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property ListBaseData As list Of web.DHCSTMService.Lis.Model.BaseDataDetail(XMLNAME = "BaseData", XMLPROJECTION = "ELEMENT");

// Property MATERIALCODE As %String(MAXLEN = "", XMLNAME = "MATERIALCODE");

}
