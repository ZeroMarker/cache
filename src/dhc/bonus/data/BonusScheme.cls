/// FA奖金核算方案
Class dhc.bonus.data.BonusScheme Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSchemeID ]
{

Property BonusSchemeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ Required, SqlColumnNumber = 2 ];

Property BonusSchemeName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property SchemeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property SchemeType As dhc.bonus.data.BonusSchemeType [ SqlColumnNumber = 5 ];

Property CreatePerson As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property AdjustPerson As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property SchemeState As %Library.Integer [ SqlColumnNumber = 8 ];

Property AdjustDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9 ];

Property AuditingPerson As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Property AuditingDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 12 ];

Property Priority As %Library.String [ SqlColumnNumber = 13 ];

Property CalculateWay As %Library.Integer [ SqlColumnNumber = 14 ];

Property CalculateMethod As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

Property CalculateFlag As %Library.Integer [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="BonusSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSchemeCode</Value>
</Value>
<Value name="3">
<Value>BonusSchemeName</Value>
</Value>
<Value name="4">
<Value>SchemeDesc</Value>
</Value>
<Value name="5">
<Value>SchemeType</Value>
</Value>
<Value name="6">
<Value>CreatePerson</Value>
</Value>
<Value name="7">
<Value>AdjustPerson</Value>
</Value>
<Value name="8">
<Value>AdjustDate</Value>
</Value>
<Value name="9">
<Value>SchemeState</Value>
</Value>
<Value name="10">
<Value>AuditingPerson</Value>
</Value>
<Value name="11">
<Value>AuditingDate</Value>
</Value>
<Value name="12">
<Value>IsValid</Value>
</Value>
<Value name="13">
<Value>Priority</Value>
</Value>
<Value name="14">
<Value>CalculateWay</Value>
</Value>
<Value name="15">
<Value>CalculateMethod</Value>
</Value>
<Value name="16">
<Value>CalculateFlag</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusSchemeD</DataLocation>
<DefaultData>BonusSchemeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusSchemeD</IdLocation>
<IndexLocation>^dhcbsBonusSchemeI</IndexLocation>
<StreamLocation>^dhcbsBonusSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
