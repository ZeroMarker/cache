Class dhc.pa.data.JDBaseData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JDBaseData_rowid, SqlTableName = JDBaseData ]
{

/// JDBaseData_unitDr
Property JDBaseDataunitDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = JDBaseData_unitDr ];

/// JDBaseData_periodDr
Property JDBaseDataperiodDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JDBaseData_periodDr ];

/// JDBaseData_periodType
Property JDBaseDataperiodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JDBaseData_periodType ];

/// JDBaseData_KPIDr
Property JDBaseDataKPIDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = JDBaseData_KPIDr ];

/// JDBaseData_AValue
Property JDBaseDataAValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = JDBaseData_AValue ];

Storage Default
{
<Data name="JDBaseDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>JDBaseDataperiod</Value>
</Value>
<Value name="3">
<Value>JDBaseDataperiodType</Value>
</Value>
<Value name="4">
<Value>JDBaseDataunitDr</Value>
</Value>
<Value name="5">
<Value>JDBaseDataKPIDr</Value>
</Value>
<Value name="6">
<Value>JDBaseDataAValue</Value>
</Value>
<Value name="7">
<Value>JDBaseDataperiodDr</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.JDBaseDataD</DataLocation>
<DefaultData>JDBaseDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPAJDBaseDataD</IdLocation>
<IndexLocation>^DHCCJXPAJDBaseDataI</IndexLocation>
<StreamLocation>^dhc.pa.data.JDBaseDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
