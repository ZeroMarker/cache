Class dhc.bonus.data.BonusIssuedDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusIssuedDetailID ]
{

Property BonusIssuedMainID As dhc.bonus.data.BonusIssuedMain [ SqlColumnNumber = 2 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

//科室人数

Property PersonNum As %Library.Integer [ SqlColumnNumber = 4 ];

//发放奖金

Property IssuedBonus As %Library.Float [ SqlColumnNumber = 5 ];

//调整奖金

Property AdjustBonus As %Library.Float [ SqlColumnNumber = 6 ];

//实际奖金

Property ResultBonus As %Library.Float [ SqlColumnNumber = 7 ];

Property AdjustDate As %Library.TimeStamp [ SqlColumnNumber = 8 ];

Property AdjustPerson As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property SchemeItemID As dhc.bonus.data.BonusSchemeItem [ SqlColumnNumber = 10 ];

Property SuperiorUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 11 ];

Property SupUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

Property BonusUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

Property BonusUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 15 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

Property IsNewEmp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19 ];

/// 奖金2次调整
Property AdjustBonus2 As %Library.Float [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="BonusIssuedDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusIssuedMainID</Value>
</Value>
<Value name="3">
<Value>BonusUnitID</Value>
</Value>
<Value name="4">
<Value>PersonNum</Value>
</Value>
<Value name="5">
<Value>IssuedBonus</Value>
</Value>
<Value name="6">
<Value>AdjustBonus</Value>
</Value>
<Value name="7">
<Value>ResultBonus</Value>
</Value>
<Value name="8">
<Value>AdjustDate</Value>
</Value>
<Value name="9">
<Value>AdjustPerson</Value>
</Value>
<Value name="10">
<Value>SchemeItemID</Value>
</Value>
<Value name="11">
<Value>SuperiorUnitID</Value>
</Value>
<Value name="12">
<Value>SupUnitName</Value>
</Value>
<Value name="13">
<Value>BonusUnitCode</Value>
</Value>
<Value name="14">
<Value>BonusUnitName</Value>
</Value>
<Value name="15">
<Value>UpdateDate</Value>
</Value>
<Value name="16">
<Value>BonusYear</Value>
</Value>
<Value name="17">
<Value>BonusPeriod</Value>
</Value>
<Value name="18">
<Value>IsNewEmp</Value>
</Value>
<Value name="19">
<Value>Remark</Value>
</Value>
<Value name="20">
<Value>AdjustBonus2</Value>
</Value>
</Data>
<DataLocation>^dhcbsIssuedDetailD</DataLocation>
<DefaultData>BonusIssuedDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsIssuedDetailD</IdLocation>
<IndexLocation>^dhcbsIssuedDetailI</IndexLocation>
<StreamLocation>^dhcbsIssuedDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
