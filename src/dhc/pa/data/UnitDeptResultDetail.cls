/// UnitResultDetail
Class dhc.pa.data.UnitDeptResultDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UDRD_rowid, SqlTableName = UnitDeptResultDetail ]
{

/// 自查科室主表id
Property unitDeptResultDR As dhc.pa.data.UnitDeptResult [ SqlColumnNumber = 2, SqlFieldName = UDRD_UDResult ];

/// 自查明显表id
Property UnitResultDetailsDetailDr As dhc.pa.data.DeptSchemDetail [ SqlColumnNumber = 3, SqlFieldName = UDRD_DsDetailDr ];

/// 自查项目id
Property DKPIDr As dhc.pa.data.DeptKPIIndex [ SqlColumnNumber = 4, SqlFieldName = UDRD_DKPIDr ];

/// 顺序号
Property order As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = UDRD_order ];

/// 扣分系数
Property rate As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = UDRD_rate ];

/// 分数
Property score As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = UDRD_score ];

/// 填报内容
Property estDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = UDRD_estDesc ];

/// 填报要求
Property fBDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = UDRD_fBDesc ];

/// 上级项目id
Property parent As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = UDRD_parent ];

/// 附件路径
Property load As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = UDRD_load ];

Index unitDeptResult On unitDeptResultDR;

Index DetailDKPI On DKPIDr;

Index unitDeptResultDKPI On (unitDeptResultDR, DKPIDr);

Storage Default
{
<Data name="UnitDeptResultDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>unitDeptResultDR</Value>
</Value>
<Value name="3">
<Value>UnitResultDetailsDetailDr</Value>
</Value>
<Value name="4">
<Value>DKPIDr</Value>
</Value>
<Value name="5">
<Value>order</Value>
</Value>
<Value name="6">
<Value>rate</Value>
</Value>
<Value name="7">
<Value>score</Value>
</Value>
<Value name="8">
<Value>estDesc</Value>
</Value>
<Value name="9">
<Value>fBDesc</Value>
</Value>
<Value name="10">
<Value>parent</Value>
</Value>
<Value name="11">
<Value>load</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPAUnitDeptResultDetailD</DataLocation>
<DefaultData>UnitDeptResultDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPAUnitDeptResultDetailD</IdLocation>
<IndexLocation>^DHCCJXPAUnitDepResultDetailI</IndexLocation>
<StreamLocation>^DHCCJXPAUnitDeptRes7763S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
