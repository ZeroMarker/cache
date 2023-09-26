Class DHCINSU.Model.BJ.INSUTradeinfo Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "tradeinfo";

Property curetype As %String;

Property illtype As %String;

Property feeno As %String;

Property operator As %String;

//output独有

//tradeno

//feeno

//tradedate

Property tradeno As %String;

Property tradedate As %String;

Storage Default
{
<Data name="INSUTradeinfoState">
<Value name="1">
<Value>curetype</Value>
</Value>
<Value name="2">
<Value>illtype</Value>
</Value>
<Value name="3">
<Value>feeno</Value>
</Value>
<Value name="4">
<Value>operator</Value>
</Value>
<Value name="5">
<Value>INSUTradeinfo</Value>
</Value>
</Data>
<State>INSUTradeinfoState</State>
<StreamLocation>^DHCINSU.Mode5F28.INSUTradeinfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
