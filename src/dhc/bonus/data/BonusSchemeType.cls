/// FA奖金方案类别
Class dhc.bonus.data.BonusSchemeType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSchemeTypeID ]
{

Property SchemeTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property SchemeTypeName As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BonusSchemeTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchemeTypeCode</Value>
</Value>
<Value name="3">
<Value>SchemeTypeName</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcbsSchemeTypeD</DataLocation>
<DefaultData>BonusSchemeTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSchemeTypeD</IdLocation>
<IndexLocation>^dhcbsSchemeTypeI</IndexLocation>
<StreamLocation>^dhcbsSchemeTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
