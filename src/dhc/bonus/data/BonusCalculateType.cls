/// 单元核算类型字典
Class dhc.bonus.data.BonusCalculateType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusCalculateTypeID ]
{

Property CalculateTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property CalculateTypeName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property CalculateTypeGroupID As dhc.bonus.data.BonusCalculateTypeGroup [ SqlColumnNumber = 4 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BonusCalculateTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CalculateTypeCode</Value>
</Value>
<Value name="3">
<Value>CalculateTypeName</Value>
</Value>
<Value name="4">
<Value>CalculateTypeGroupID</Value>
</Value>
<Value name="5">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcbsCalculateTypD</DataLocation>
<DefaultData>BonusCalculateTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsCalculateTypDD</IdLocation>
<IndexLocation>^dhcbsCalculateTypDI</IndexLocation>
<StreamLocation>^dhcbsCalculateTypDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
