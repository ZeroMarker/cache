Class DWR.DIA.MSG.ICDQryRp Extends (%RegisteredObject, XT.Common.Msg.Response, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// ICD列表
Property ICDList As list Of DWR.DIA.MSG.ICD;

Storage Default
{
<Data name="ICDQryRpDefaultData">
<Subscript>"ICDQryRp"</Subscript>
<Value name="1">
<Value>ICDS</Value>
</Value>
<Value name="2">
<Value>ResultCode</Value>
</Value>
<Value name="3">
<Value>ResultContent</Value>
</Value>
<Value name="4">
<Value>ICDList</Value>
</Value>
</Data>
<DefaultData>ICDQryRpDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
