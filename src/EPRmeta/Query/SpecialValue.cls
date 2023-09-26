/// 查询结果特殊值字典表
Class EPRmeta.Query.SpecialValue Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Name As %String(TRUNCATE = 1) [ Required ];

Property Code As %String(TRUNCATE = 1) [ Required ];

Property IsActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

Storage Default
{
<Data name="SpecialValueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.SpecialValueD</DataLocation>
<DefaultData>SpecialValueDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.SpecialValueD</IdLocation>
<IndexLocation>^DHCEPRM.SpecialValueI</IndexLocation>
<StreamLocation>^DHCEPRM.SpecialValueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
