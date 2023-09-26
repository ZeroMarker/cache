/// XML Print Config.
Class User.DHCXMLPConfig Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_XMLPConfig ]
{

Index XPCFlagIndex On XPCFlag [ Unique ];

Property XPCFileData As %GlobalCharacterStream [ SqlFieldName = XPC_FileData ];

Property XPCFlag As %String(TRUNCATE = 1) [ SqlFieldName = XPC_Flag ];

Property XPCNote1 As %String(TRUNCATE = 1) [ SqlFieldName = XPC_Note1 ];

Property XPCNote2 As %String(TRUNCATE = 1) [ SqlFieldName = XPC_Note2 ];

Storage Default
{
<Data name="DHCXMLPConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>XPCFileData</Value>
</Value>
<Value name="3">
<Value>XPCFlag</Value>
</Value>
<Value name="4">
<Value>XPCNote1</Value>
</Value>
<Value name="5">
<Value>XPCNote2</Value>
</Value>
</Data>
<DataLocation>^User.DHCXMLPConfigD</DataLocation>
<DefaultData>DHCXMLPConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCXMLPConfigD</IdLocation>
<IndexLocation>^User.DHCXMLPConfigI</IndexLocation>
<StreamLocation>^User.DHCXMLPConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
