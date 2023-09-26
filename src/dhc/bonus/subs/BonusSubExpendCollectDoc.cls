/// /                                                                                                             
Class dhc.bonus.subs.BonusSubExpendCollectDoc Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BsbExpendCollectDocID ]
{

Property ExpendItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property ExpenItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property BonusUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property BonusUnitName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property resDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property resDocDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property CalculateUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Property ItemValue As %Library.Float [ SqlColumnNumber = 11 ];

Property InterLocMethodID As dhc.bonus.inter.InterLocMethod [ SqlColumnNumber = 12 ];

Property CollectDate As %Library.TimeStamp [ SqlColumnNumber = 13 ];

Property State As %Library.Integer [ SqlColumnNumber = 14 ];

Property UnitType As %Library.Integer [ SqlColumnNumber = 15 ];

Property AuditingDate As %Library.TimeStamp [ SqlColumnNumber = 16 ];

Property CalculateRate As %Library.Float [ Required, SqlColumnNumber = 17 ];

Property ExecuteRate As %Library.Float [ Required, SqlColumnNumber = 18 ];

Storage Default
{
<Data name="BonusSubExpendCollectDocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AuditingDate</Value>
</Value>
<Value name="3">
<Value>BonusPeriod</Value>
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
<Value>CalculateUnit</Value>
</Value>
<Value name="8">
<Value>CollectDate</Value>
</Value>
<Value name="9">
<Value>ExecuteDeptCode</Value>
</Value>
<Value name="10">
<Value>ExecuteDeptName</Value>
</Value>
<Value name="11">
<Value>ExpenItemName</Value>
</Value>
<Value name="12">
<Value>ExpendItemCode</Value>
</Value>
<Value name="13">
<Value>InterLocMethodID</Value>
</Value>
<Value name="14">
<Value>ItemValue</Value>
</Value>
<Value name="15">
<Value>State</Value>
</Value>
<Value name="16">
<Value>UnitType</Value>
</Value>
<Value name="17">
<Value>resDocCode</Value>
</Value>
<Value name="18">
<Value>resDocDesc</Value>
</Value>
<Value name="19">
<Value>CalculateRate</Value>
</Value>
<Value name="20">
<Value>ExecuteRate</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubExpendCollectDocD</DataLocation>
<DefaultData>BonusSubExpendCollectDocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubExpendCollectDocD</IdLocation>
<IndexLocation>^dhcbsSubExpendCollectDocI</IndexLocation>
<StreamLocation>^dhcbsSubExpendCollectDocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
