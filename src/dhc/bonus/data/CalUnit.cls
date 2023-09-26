/// ZD奖金指标类别
Class dhc.bonus.data.CalUnit Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CalUnitID ]
{

Index Code On CalUnitCode As Exact;

Index Name On CalUnitName As Exact;

Property CalUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property CalUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property IsValid As %Integer [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="CalUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CalUnitCode</Value>
</Value>
<Value name="3">
<Value>CalUnitName</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcbsCalUnitD</DataLocation>
<DefaultData>CalUnitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsCalUnitD</IdLocation>
<IndexLocation>^dhcbsCalUnitI</IndexLocation>
<StreamLocation>^dhcbsCalUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
