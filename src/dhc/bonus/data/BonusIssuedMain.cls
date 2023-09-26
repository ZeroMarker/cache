/// FA核算单元奖金主表
Class dhc.bonus.data.BonusIssuedMain Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusIssuedMainID ]
{

Property BonusSchemeID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 2 ];

Property SupBonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property SchemeItemID As dhc.bonus.data.BonusSchemeItem [ SqlColumnNumber = 6 ];

Property ResultBonus As %Library.Float [ SqlColumnNumber = 7 ];

Property PersonNum As %Library.Integer [ SqlColumnNumber = 8 ];

Property DataStatus As %Library.Integer [ SqlColumnNumber = 9 ];

Property IssuedDate As %Library.TimeStamp [ SqlColumnNumber = 10 ];

Property IssuedPerson As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

Property DeptUpDate As %Library.TimeStamp [ SqlColumnNumber = 12 ];

Property DeptUpPerson As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

Property UpFinanceDate As %Library.TimeStamp [ SqlColumnNumber = 14 ];

Property UpFinancePerson As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 16 ];

Property UnitFlag As %Library.String(MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

Property CheckDate As %Library.TimeStamp [ SqlColumnNumber = 19 ];

Property CheckPerson As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 20 ];

/// 科室本期发金额
Property PayBonus As %Library.Float [ SqlColumnNumber = 21 ];

/// 科室上期余额
Property PayBalance As %Library.Float [ SqlColumnNumber = 22 ];

Index GetMainId On (BonusSchemeID, SupBonusUnitID, BonusYear, BonusPeriod, SchemeItemID);

Storage Default
{
<Data name="BonusIssuedMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSchemeID</Value>
</Value>
<Value name="3">
<Value>BonusYear</Value>
</Value>
<Value name="4">
<Value>BonusPeriod</Value>
</Value>
<Value name="5">
<Value>SupBonusUnitID</Value>
</Value>
<Value name="6">
<Value>SchemeItemID</Value>
</Value>
<Value name="7">
<Value>ResultBonus</Value>
</Value>
<Value name="8">
<Value>PersonNum</Value>
</Value>
<Value name="9">
<Value>IssuedDate</Value>
</Value>
<Value name="10">
<Value>IssuedPerson</Value>
</Value>
<Value name="11">
<Value>DeptUpDate</Value>
</Value>
<Value name="12">
<Value>DeptUpPerson</Value>
</Value>
<Value name="13">
<Value>UpFinanceDate</Value>
</Value>
<Value name="14">
<Value>UpFinancePerson</Value>
</Value>
<Value name="15">
<Value>DataStatus</Value>
</Value>
<Value name="16">
<Value>BonusUnitID</Value>
</Value>
<Value name="17">
<Value>UnitFlag</Value>
</Value>
<Value name="18">
<Value>Remark</Value>
</Value>
<Value name="19">
<Value>CheckDate</Value>
</Value>
<Value name="20">
<Value>CheckPerson</Value>
</Value>
<Value name="21">
<Value>PayBonus</Value>
</Value>
<Value name="22">
<Value>PayBalance</Value>
</Value>
</Data>
<DataLocation>^dhcbsIssuedMainD</DataLocation>
<DefaultData>BonusIssuedMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsIssuedMainD</IdLocation>
<IndexLocation>^dhcbsIssuedMainI</IndexLocation>
<StreamLocation>^dhcbsIssuedMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
