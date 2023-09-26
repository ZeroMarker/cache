/// ZD奖金指标类别
Class dhc.bonus.data.TargetType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = TargetTypeID ]
{

Index Code On TargetTypeCode As Exact;

Index Name On TargetTypeName As Exact;

Property IsValid As %Integer [ Required, SqlColumnNumber = 4 ];

Property TargetTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property TargetTypeName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Storage Default
{
<Data name="TargetTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TargetTypeCode</Value>
</Value>
<Value name="3">
<Value>TargetTypeName</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcbsTargetTypeD</DataLocation>
<DefaultData>TargetTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsTargetTypeD</IdLocation>
<IndexLocation>^dhcbsTargetTypeI</IndexLocation>
<StreamLocation>^dhcbsTargetTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
