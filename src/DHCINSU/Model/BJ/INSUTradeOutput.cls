Class DHCINSU.Model.BJ.INSUTradeOutput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "output";

Property personcountaftersub As %String;

Property certid As %String;

//string默认长度

Property sign As %String(MAXLEN = 1000);

}
