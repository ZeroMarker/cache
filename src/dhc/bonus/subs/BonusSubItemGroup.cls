/// SH收费项目组BonusSubItemGroup
Class dhc.bonus.subs.BonusSubItemGroup Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubItemGroupID ]
{

Property SubItemGroupCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property SubItemGroupName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BonusSubItemGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsValid</Value>
</Value>
<Value name="3">
<Value>SubItemGroupCode</Value>
</Value>
<Value name="4">
<Value>SubItemGroupName</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubItemGroupD</DataLocation>
<DefaultData>BonusSubItemGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubItemGroupD</IdLocation>
<IndexLocation>^dhcbsSubItemGroupI</IndexLocation>
<StreamLocation>^dhcbsSubItemGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
