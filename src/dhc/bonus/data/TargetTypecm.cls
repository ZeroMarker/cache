Class dhc.bonus.data.TargetTypecm Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = TargetTypecmID ]
{

Index Code On TargetTypecmCode As Exact;

Index Name On TargetTypecmName As Exact;

Index Desc On TargetTypecmDesc As Exact;

Property IsValid As %Integer [ Required, SqlColumnNumber = 5 ];

Property TargetTypecmCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property TargetTypecmName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property TargetTypecmDesc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="TargetTypecmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsValid</Value>
</Value>
<Value name="3">
<Value>TargetTypecmCode</Value>
</Value>
<Value name="4">
<Value>TargetTypecmName</Value>
</Value>
<Value name="5">
<Value>TargetTypecmDesc</Value>
</Value>
</Data>
<DataLocation>^dhcbsTargetTypecmD</DataLocation>
<DefaultData>TargetTypecmDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsTargetTypecmD</IdLocation>
<IndexLocation>^dhcbsTargetTypecmI</IndexLocation>
<StreamLocation>^dhcbsTargetTypecmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
