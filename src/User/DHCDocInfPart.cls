/// 抗菌药物感染部位
Class User.DHCDocInfPart Extends (%Persistent, %XML.Adaptor) [ Not ProcedureBlock, SqlTableName = DHC_Doc_InfPart ]
{

/// 代码
Property IPCode As %String(TRUNCATE = 1) [ Required ];

/// 描述
Property IPDesc As %String(TRUNCATE = 1) [ Required ];

/// 是否有效
Property IPActive As %Boolean;

/// 备注
Property IPResume As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCDocInfPartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IPCode</Value>
</Value>
<Value name="3">
<Value>IPDesc</Value>
</Value>
<Value name="4">
<Value>IPActive</Value>
</Value>
<Value name="5">
<Value>IPResume</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocInfPartD</DataLocation>
<DefaultData>DHCDocInfPartDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCDocInfPartD</IdLocation>
<IndexLocation>^User.DHCDocInfPartI</IndexLocation>
<StreamLocation>^User.DHCDocInfPartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
