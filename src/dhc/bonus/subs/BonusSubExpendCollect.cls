/// SH支出项目采集表BonusSubExpendCollect                                                                                                                
Class dhc.bonus.subs.BonusSubExpendCollect Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubExpendCollectID ]
{

Property ExpendItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property ExpenItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property BonusUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property BonusUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property ExecuteDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property ExecuteDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property CalculateUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Property ItemValue As %Library.Float [ SqlColumnNumber = 11 ];

Property InterLocMethodID As dhc.bonus.inter.InterLocMethod [ SqlColumnNumber = 12 ];

Property CollectDate As %Library.TimeStamp [ SqlColumnNumber = 13 ];

Property State As %Library.Integer [ SqlColumnNumber = 14 ];

Property UnitType As %Library.Integer [ SqlColumnNumber = 15 ];

Property DataUpDate As %Library.TimeStamp [ SqlColumnNumber = 16 ];

Property ItemNum As %Library.Float [ SqlColumnNumber = 17 ];

Property ItemPrice As %Library.Float [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="BonusSubExpendCollectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExpendItemCode</Value>
</Value>
<Value name="3">
<Value>ExpenItemName</Value>
</Value>
<Value name="4">
<Value>BonusUnitCode</Value>
</Value>
<Value name="5">
<Value>BonusUnitName</Value>
</Value>
<Value name="6">
<Value>BonusYear</Value>
</Value>
<Value name="7">
<Value>BonusPeriod</Value>
</Value>
<Value name="8">
<Value>ExecuteDeptCode</Value>
</Value>
<Value name="9">
<Value>ExecuteDeptName</Value>
</Value>
<Value name="10">
<Value>CalculateUnit</Value>
</Value>
<Value name="11">
<Value>ItemValue</Value>
</Value>
<Value name="12">
<Value>InterLocMethodID</Value>
</Value>
<Value name="13">
<Value>CollectDate</Value>
</Value>
<Value name="14">
<Value>State</Value>
</Value>
<Value name="15">
<Value>UnitType</Value>
</Value>
<Value name="16">
<Value>DataUpDate</Value>
</Value>
<Value name="17">
<Value>DocCode</Value>
</Value>
<Value name="18">
<Value>DocName</Value>
</Value>
<Value name="19">
<Value>ItemNum</Value>
</Value>
<Value name="20">
<Value>ItemPrice</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubExpendCollectD</DataLocation>
<DefaultData>BonusSubExpendCollectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubExpendCollectD</IdLocation>
<IndexLocation>^dhcbsSubExpendCollectI</IndexLocation>
<StreamLocation>^dhcbsSubExpendCollectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
