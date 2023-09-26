/// Class dhc.bonus.subs.workload Extends %Persistent
Class dhc.bonus.subs.workload Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BsbExpendCollectDocID ]
{

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

//开单时间

Property OrdDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

//就诊时间

Property AdmDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property PatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property PatDepDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property RecDepDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property ResDoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property RecDoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Property TarNums As %Library.Float [ SqlColumnNumber = 11 ];

Property TarPrice As %Library.Float [ SqlColumnNumber = 12 ];

Property PatRate As %Library.Float [ SqlColumnNumber = 13 ];

Property RecRate As %Library.Float [ SqlColumnNumber = 14 ];

Property ResRate As %Library.Float [ SqlColumnNumber = 15 ];

Property TotalPrice As %Library.Float [ SqlColumnNumber = 16 ];

Property TarItmEMCCate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

Property Flag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

Property UpdateDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19 ];

Property YearMonth As %Library.String(COLLATION = "Exact", MAXLEN = 31, TRUNCATE = 0) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="workloadDefaultData">
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
<Value>OrdDate</Value>
</Value>
<Value name="5">
<Value>AdmDate</Value>
</Value>
<Value name="6">
<Value>PatType</Value>
</Value>
<Value name="7">
<Value>PatDepDr</Value>
</Value>
<Value name="8">
<Value>RecDepDr</Value>
</Value>
<Value name="9">
<Value>ResDoc</Value>
</Value>
<Value name="10">
<Value>RecDoc</Value>
</Value>
<Value name="11">
<Value>TarNums</Value>
</Value>
<Value name="12">
<Value>TotalPrice</Value>
</Value>
<Value name="13">
<Value>TarItmEMCCate</Value>
</Value>
<Value name="14">
<Value>Flag</Value>
</Value>
<Value name="15">
<Value>UpdateDate</Value>
</Value>
<Value name="16">
<Value>YearMonth</Value>
</Value>
<Value name="17">
<Value>TarPrice</Value>
</Value>
<Value name="18">
<Value>PatRate</Value>
</Value>
<Value name="19">
<Value>RecRate</Value>
</Value>
<Value name="20">
<Value>ResRate</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubsWorkloadD</DataLocation>
<DefaultData>workloadDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubsWorkloadD</IdLocation>
<IndexLocation>^dhcbsSubsWorkloadI</IndexLocation>
<StreamLocation>^dhcbsSubsWorkloadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
