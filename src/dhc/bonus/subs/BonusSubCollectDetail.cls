Class dhc.bonus.subs.BonusSubCollectDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BsbExpendCollectDocID ]
{

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property OrdDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property ExcDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property OrdDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property ExcDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property DataType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Property ItemValue As %Library.Float [ SqlColumnNumber = 11 ];

Property InterLocMethodID As dhc.bonus.inter.InterLocMethod [ SqlColumnNumber = 12 ];

Property CollectDate As %Library.TimeStamp [ SqlColumnNumber = 13 ];

Property OeiFlag As %Library.String [ SqlColumnNumber = 14 ];

Property ExcFlag As %Library.String [ SqlColumnNumber = 15 ];

Property CalculateRate As %Library.Float [ Required, SqlColumnNumber = 16 ];

Property ExecuteRate As %Library.Float [ Required, SqlColumnNumber = 17 ];

Property remark As %Library.String [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="BonusSubCollectDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemName</Value>
</Value>
<Value name="4">
<Value>OrdDeptCode</Value>
</Value>
<Value name="5">
<Value>ExcDeptCode</Value>
</Value>
<Value name="6">
<Value>BonusYear</Value>
</Value>
<Value name="7">
<Value>BonusPeriod</Value>
</Value>
<Value name="8">
<Value>OrdDocCode</Value>
</Value>
<Value name="9">
<Value>ExcDocCode</Value>
</Value>
<Value name="10">
<Value>DataType</Value>
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
<Value>OeiFlag</Value>
</Value>
<Value name="15">
<Value>ExcFlag</Value>
</Value>
<Value name="16">
<Value>CalculateRate</Value>
</Value>
<Value name="17">
<Value>ExecuteRate</Value>
</Value>
<Value name="18">
<Value>remark</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubCollectDetailD</DataLocation>
<DefaultData>BonusSubCollectDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubCollectDetailD</IdLocation>
<IndexLocation>^dhcbsSubCollectDetailI</IndexLocation>
<StreamLocation>^dhcbsSubCollectDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
