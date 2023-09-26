Class dhc.ca.cache.data.OIncomeDatas Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OIncomeDatas_rowid, SqlTableName = OIncomeDatas ]
{

Parameter EXTENTSIZE = 250;

/// OIncomeDatas_intervalDr
Property OIncomeDatasintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 2, SqlFieldName = OIncomeDatas_intervalDr ];

/// OIncomeDatas_feeDate
Property OIncomeDatasfeeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = OIncomeDatas_feeDate ];

/// OIncomeDatas_patType
Property OIncomeDataspatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OIncomeDatas_patType ];

/// OIncomeDatas_itemCode
Property OIncomeDatasitemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OIncomeDatas_itemCode ];

/// OIncomeDatas_itemName
Property OIncomeDatasitemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = OIncomeDatas_itemName ];

/// OIncomeDatas_itemDr
Property OIncomeDatasitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 7, SqlFieldName = OIncomeDatas_itemDr ];

/// OIncomeDatas_fee
Property OIncomeDatasfee As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = OIncomeDatas_fee ];

/// OIncomeDatas_cost
Property OIncomeDatascost As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = OIncomeDatas_cost ];

/// OIncomeDatas_fDeptCode
Property OIncomeDatasfDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = OIncomeDatas_fDeptCode ];

/// OIncomeDatas_fDeptName
Property OIncomeDatasfDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = OIncomeDatas_fDeptName ];

/// OIncomeDatas_fDeptDr
Property OIncomeDatasfDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 12, SqlFieldName = OIncomeDatas_fDeptDr ];

/// OIncomeDatas_tDeptCode
Property OIncomeDatastDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = OIncomeDatas_tDeptCode ];

/// OIncomeDatas_tDeptName
Property OIncomeDatastDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = OIncomeDatas_tDeptName ];

/// OIncomeDatas_tDeptDr
Property OIncomeDatastDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 15, SqlFieldName = OIncomeDatas_tDeptDr ];

/// OIncomeDatas_patDeptCode
Property OIncomeDataspatDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = OIncomeDatas_patDeptCode ];

/// OIncomeDatas_patDeptName
Property OIncomeDataspatDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = OIncomeDatas_patDeptName ];

/// OIncomeDatas_patDeptDr
Property OIncomeDataspatDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 18, SqlFieldName = OIncomeDatas_patDeptDr ];

/// OIncomeDatas_inType
Property OIncomeDatasinType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = OIncomeDatas_inType ];

/// OIncomeDatas_inPersonDr
Property OIncomeDatasinPersonDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 20, SqlFieldName = OIncomeDatas_inPersonDr ];

/// OIncomeDatas_remark
Property OIncomeDatasremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = OIncomeDatas_remark ];

/// OIncomeDatas_inDate
Property OIncomeDatasinDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = OIncomeDatas_inDate ];

/// OIncomeDatas_PatWardCode
Property OIncomeDatasPatWardCode As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = OIncomeDatas_PatWardCode ];

/// OIncomeDatas_PatWardDesc
Property OIncomeDatasPatWardDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = OIncomeDatas_PatWardDesc ];

/// OIncomeDatas_PatWardDr
Property OIncomeDatasPatWardDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 25, SqlFieldName = OIncomeDatas_PatWardDr ];

/// OIncomeDatas_PatDocCode
Property OIncomeDatasPatDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = OIncomeDatas_PatDocCode ];

/// OIncomeDatas_PatDocDesc
Property OIncomeDatasPatDocDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = OIncomeDatas_PatDocDesc ];

/// OIncomeDatas_PatDocDr
Property OIncomeDatasPatDocDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 28, SqlFieldName = OIncomeDatas_PatDocDr ];

/// OIncomeDatas_fDocCode
Property OIncomeDatasfDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = OIncomeDatas_fDocCode ];

/// OIncomeDatas_fDocName
Property OIncomeDatasfDocName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = OIncomeDatas_fDocName ];

/// OIncomeDatas_fDocDr
Property OIncomeDatasfDocDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 31, SqlFieldName = OIncomeDatas_fDocDr ];

Storage Default
{
<Data name="OIncomeDatasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OIncomeDatasPatDocCode</Value>
</Value>
<Value name="3">
<Value>OIncomeDatasPatDocDesc</Value>
</Value>
<Value name="4">
<Value>OIncomeDatasPatDocDr</Value>
</Value>
<Value name="5">
<Value>OIncomeDatasPatWardCode</Value>
</Value>
<Value name="6">
<Value>OIncomeDatasPatWardDesc</Value>
</Value>
<Value name="7">
<Value>OIncomeDatasPatWardDr</Value>
</Value>
<Value name="8">
<Value>OIncomeDatascost</Value>
</Value>
<Value name="9">
<Value>OIncomeDatasfDeptCode</Value>
</Value>
<Value name="10">
<Value>OIncomeDatasfDeptDr</Value>
</Value>
<Value name="11">
<Value>OIncomeDatasfDeptName</Value>
</Value>
<Value name="12">
<Value>OIncomeDatasfDocCode</Value>
</Value>
<Value name="13">
<Value>OIncomeDatasfDocDr</Value>
</Value>
<Value name="14">
<Value>OIncomeDatasfDocName</Value>
</Value>
<Value name="15">
<Value>OIncomeDatasfee</Value>
</Value>
<Value name="16">
<Value>OIncomeDatasfeeDate</Value>
</Value>
<Value name="17">
<Value>OIncomeDatasinDate</Value>
</Value>
<Value name="18">
<Value>OIncomeDatasinPersonDr</Value>
</Value>
<Value name="19">
<Value>OIncomeDatasinType</Value>
</Value>
<Value name="20">
<Value>OIncomeDatasintervalDr</Value>
</Value>
<Value name="21">
<Value>OIncomeDatasitemCode</Value>
</Value>
<Value name="22">
<Value>OIncomeDatasitemDr</Value>
</Value>
<Value name="23">
<Value>OIncomeDatasitemName</Value>
</Value>
<Value name="24">
<Value>OIncomeDataspatDeptCode</Value>
</Value>
<Value name="25">
<Value>OIncomeDataspatDeptDr</Value>
</Value>
<Value name="26">
<Value>OIncomeDataspatDeptName</Value>
</Value>
<Value name="27">
<Value>OIncomeDataspatType</Value>
</Value>
<Value name="28">
<Value>OIncomeDatasremark</Value>
</Value>
<Value name="29">
<Value>OIncomeDatastDeptCode</Value>
</Value>
<Value name="30">
<Value>OIncomeDatastDeptDr</Value>
</Value>
<Value name="31">
<Value>OIncomeDatastDeptName</Value>
</Value>
</Data>
<DataLocation>^DHCCAOINCOMEDATASD</DataLocation>
<DefaultData>OIncomeDatasDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCCAOINCOMEDATASD</IdLocation>
<IndexLocation>^DHCCAOINCOMEDATASI</IndexLocation>
<StreamLocation>^dhc.ca.cache.d60B.OIncomeDatasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
