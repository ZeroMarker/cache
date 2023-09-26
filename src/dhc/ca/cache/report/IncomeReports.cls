Class dhc.ca.cache.report.IncomeReports Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Parameter EXTENTSIZE = 250;

/// IncomeDatas_intervalDr
Property IncomeDatasintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 2, SqlFieldName = IncomeDatas_intervalDr ];

/// IncomeDatas_intervalName
Property IncomeDatasintervalName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IncomeDatas_intervalName ];

/// IncomeDatas_patType
Property IncomeDataspatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IncomeDatas_patType ];

/// IncomeDatas_itemDr
Property IncomeDatasitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 5, SqlFieldName = IncomeDatas_itemDr ];

/// IncomeDatas_itemName
Property IncomeDatasitemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IncomeDatas_itemName ];

/// IncomeDatas_fee
Property IncomeDatasfee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = IncomeDatas_fee ];

/// IncomeDatas_cost
Property IncomeDatascost As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = IncomeDatas_cost ];

/// IncomeDatas_fDeptDr
Property IncomeDatasfDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 9, SqlFieldName = IncomeDatas_fDeptDr ];

/// IncomeDatas_fDeptName
Property IncomeDatasfDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IncomeDatas_fDeptName ];

/// IncomeDatas_tDeptDr
Property IncomeDatastDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 11, SqlFieldName = IncomeDatas_tDeptDr ];

/// IncomeDatas_tDeptName
Property IncomeDatastDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IncomeDatas_tDeptName ];

/// IncomeDatas_patDeptDr
Property IncomeDataspatDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 13, SqlFieldName = IncomeDatas_patDeptDr ];

/// IncomeDatas_patDeptName
Property IncomeDataspatDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IncomeDatas_patDeptName ];

/// IncomeDatas_inType
Property IncomeDatasinType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IncomeDatas_inType ];

Storage Default
{
<Data name="IncomeReportsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IncomeDatascost</Value>
</Value>
<Value name="3">
<Value>IncomeDatasfDeptDr</Value>
</Value>
<Value name="4">
<Value>IncomeDatasfDeptName</Value>
</Value>
<Value name="5">
<Value>IncomeDatasfee</Value>
</Value>
<Value name="6">
<Value>IncomeDatasfeeDate</Value>
</Value>
<Value name="7">
<Value>IncomeDatasinType</Value>
</Value>
<Value name="8">
<Value>IncomeDatasintervalDr</Value>
</Value>
<Value name="9">
<Value>IncomeDatasintervalName</Value>
</Value>
<Value name="10">
<Value>IncomeDatasitemDr</Value>
</Value>
<Value name="11">
<Value>IncomeDatasitemName</Value>
</Value>
<Value name="12">
<Value>IncomeDataspatDeptDr</Value>
</Value>
<Value name="13">
<Value>IncomeDataspatDeptName</Value>
</Value>
<Value name="14">
<Value>IncomeDataspatType</Value>
</Value>
<Value name="15">
<Value>IncomeDatastDeptDr</Value>
</Value>
<Value name="16">
<Value>IncomeDatastDeptName</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.IncomeReportsD</DataLocation>
<DefaultData>IncomeReportsDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^dhc.ca.c.IncomeReportsD</IdLocation>
<IndexLocation>^dhc.ca.c.IncomeReportsI</IndexLocation>
<StreamLocation>^dhc.ca.c.IncomeReportsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
