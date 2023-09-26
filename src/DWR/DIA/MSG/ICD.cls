/// ICD信息
Class DWR.DIA.MSG.ICD Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "ICD";

/// 诊断ID
Property ICDID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 诊断代码
Property ICDCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断名称
Property ICDDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 索引字符串
Property IndexStr As %String(MAXLEN = 200, TRUNCATE = 1);

Storage Default
{
<Data name="ICDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICDCode</Value>
</Value>
<Value name="3">
<Value>ICDID</Value>
</Value>
<Value name="4">
<Value>ICDName</Value>
</Value>
<Value name="5">
<Value>ICDDesc</Value>
</Value>
<Value name="6">
<Value>IndexStr</Value>
</Value>
</Data>
<DataLocation>^DWR.DIA.MSG.ICDD</DataLocation>
<DefaultData>ICDDefaultData</DefaultData>
<IdLocation>^DWR.DIA.MSG.ICDD</IdLocation>
<IndexLocation>^DWR.DIA.MSG.ICDI</IndexLocation>
<StreamLocation>^DWR.DIA.MSG.ICDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
