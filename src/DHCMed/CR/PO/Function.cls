/// 名称: DHCMed.CR.PO.Function
/// 描述: Javascript函数
/// 编写者：wuqk
/// 编写日期: 2012-11-27
Class DHCMed.CR.PO.Function Extends (%Persistent, %XML.Adaptor)
{

Property name As %String(XMLPROJECTION = "ATTRIBUTE");

Property caption As %String(XMLPROJECTION = "ATTRIBUTE");

Property type As %String(XMLPROJECTION = "ATTRIBUTE");

Property data As %XML.String(CONTENT = "STRING", MAXLEN = 3000, XMLNAME = "data", XMLPROJECTION = "");

Property description As %XML.String(CONTENT = "STRING", MAXLEN = 1000, XMLNAME = "description");

/// This parameter provides the default XMLNAME for the class. If it is
/// empty then the class name will be used to construct a default XML name.
/// 
/// The default XMLNAME is used as the top level tag 
/// when exporting objects and the export context
/// did not provide an XML container name.
Parameter XMLNAME = "item";

Query QryForExport() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,caption,data,description,name,type FROM Function
 ORDER BY %ID
}

Storage Default
{
<Data name="FunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>caption</Value>
</Value>
<Value name="4">
<Value>type</Value>
</Value>
<Value name="5">
<Value>data</Value>
</Value>
<Value name="6">
<Value>description</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CR.PO.FunctionD</DataLocation>
<DefaultData>FunctionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CR.PO.FunctionD</IdLocation>
<IndexLocation>^DHCMed.CR.PO.FunctionI</IndexLocation>
<StreamLocation>^DHCMed.CR.PO.FunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
