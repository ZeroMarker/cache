/// UnitResult
Class dhc.pa.data.UnitDeptResult Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UDR_rowid, SqlTableName = UnitDeptResult ]
{

/// 自查id
Property DschemDr As dhc.pa.data.DeptSchem [ SqlColumnNumber = 2, SqlFieldName = UDR_DschemDr ];

/// 科室id
Property jxUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 3, SqlFieldName = UDR_jxUnitDr ];

/// 期间
Property period As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UDR_period ];

/// 评审人
Property auditDr As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = UDR_auditDr ];

/// 评审时间
Property auditDate As %Library.TimeStamp [ SqlColumnNumber = 6, SqlFieldName = UDR_auditDate ];

/// 评审状态
Property auditState As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = UDR_auditState ];

/// 提交人
Property submitUser As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = UDR_submiDr ];

/// 提交时间
Property submitDate As %Library.TimeStamp [ SqlColumnNumber = 10, SqlFieldName = UDR_submiDate ];

/// 提交状态
Property submitState As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = UDR_submitState ];

/// 修改人
Property updateDr As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = UDR_updateDr ];

/// 修改时间
Property updateDate As %Library.TimeStamp [ SqlColumnNumber = 13, SqlFieldName = UDR_updateDate ];

/// 修改状态
Property updateState As %Library.String [ SqlColumnNumber = 14, SqlFieldName = UDR_updateState ];

/// 总分
Property totalScore As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = UDR_totalScore ];

Index DeptSchem On DschemDr;

Index JXUnit On jxUnitDr;

Index period On period;

Index DeptSchemPeriod On (DschemDr, period);

Index SchemPeriodJXUnit On (DschemDr, jxUnitDr, period);

Storage Default
{
<Data name="UnitDeptResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DschemDr</Value>
</Value>
<Value name="3">
<Value>jxUnitDr</Value>
</Value>
<Value name="4">
<Value>period</Value>
</Value>
<Value name="5">
<Value>auditDr</Value>
</Value>
<Value name="6">
<Value>auditDate</Value>
</Value>
<Value name="7">
<Value>auditState</Value>
</Value>
<Value name="8">
<Value>submitUser</Value>
</Value>
<Value name="9">
<Value>submitDate</Value>
</Value>
<Value name="10">
<Value>submitState</Value>
</Value>
<Value name="11">
<Value>updateDr</Value>
</Value>
<Value name="12">
<Value>updateDate</Value>
</Value>
<Value name="13">
<Value>updateState</Value>
</Value>
<Value name="14">
<Value>totalScore</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPAUnitDeptResultD</DataLocation>
<DefaultData>UnitDeptResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPAUnitDeptResultD</IdLocation>
<IndexLocation>^DHCCJXPAUnitDeptResultI</IndexLocation>
<StreamLocation>^DHCCJXPAUnitDeptResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
