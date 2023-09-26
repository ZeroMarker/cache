/// 单元核算类型分组
Class dhc.bonus.data.BonusCalculateTypeGroup Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusCalculateTypeGroupID ]
{

Index Code On CalculateGrouupCode As Exact;

Index Name On CalculateGroupName As Exact;

Property CalculateGrouupCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property CalculateGroupName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BonusCalculateTypeGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CalculateGrouupCode</Value>
</Value>
<Value name="3">
<Value>CalculateGroupName</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcbsCalculateTypeGroupD</DataLocation>
<DefaultData>BonusCalculateTypeGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsCalculateTypeGroupD</IdLocation>
<IndexLocation>^dhcbsCalculateTypeGroupI</IndexLocation>
<StreamLocation>^dhcbsCalculateTypeGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
