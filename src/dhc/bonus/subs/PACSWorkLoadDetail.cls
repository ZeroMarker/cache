/// /  记录PACS RIS 工作量明细                                                                                                           
Class dhc.bonus.subs.PACSWorkLoadDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BsbExpendCollectDocID ]
{

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property UnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property UnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property ItemValue As %Library.Float [ SqlColumnNumber = 9 ];

Property MethodID As dhc.bonus.inter.InterLocMethod [ SqlColumnNumber = 10 ];

Property CollectDate As %Library.TimeStamp [ SqlColumnNumber = 11 ];

Property State As %Library.Integer [ SqlColumnNumber = 12 ];

Property UnitType As %Library.Integer [ SqlColumnNumber = 13 ];

Property CalculateRate As %Library.Float [ Required, SqlColumnNumber = 14 ];

Property ExecuteRate As %Library.Float [ Required, SqlColumnNumber = 15 ];

Property BonusTargetCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="PACSWorkLoadDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusYear</Value>
</Value>
<Value name="3">
<Value>BonusPeriod</Value>
</Value>
<Value name="4">
<Value>UnitCode</Value>
</Value>
<Value name="5">
<Value>UnitName</Value>
</Value>
<Value name="6">
<Value>ItemCode</Value>
</Value>
<Value name="7">
<Value>ItemName</Value>
</Value>
<Value name="8">
<Value>ItemValue</Value>
</Value>
<Value name="9">
<Value>MethodID</Value>
</Value>
<Value name="10">
<Value>CollectDate</Value>
</Value>
<Value name="11">
<Value>State</Value>
</Value>
<Value name="12">
<Value>UnitType</Value>
</Value>
<Value name="13">
<Value>CalculateRate</Value>
</Value>
<Value name="14">
<Value>ExecuteRate</Value>
</Value>
<Value name="15">
<Value>BonusTargetCode</Value>
</Value>
</Data>
<DataLocation>^dhcbsPACSWorkLoadDetailD</DataLocation>
<DefaultData>PACSWorkLoadDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsPACSWorkLoadDetailD</IdLocation>
<IndexLocation>^dhcbsPACSWorkLoadDetailI</IndexLocation>
<StreamLocation>^dhcbsPACSWorkLoadDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
