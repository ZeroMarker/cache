/// DeptSchemDetail 自查明细表
Class dhc.pa.data.DeptSchemDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSD_rowid, SqlTableName = DeptSchemDetail ]
{

/// 顺序
Property order As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DSD_order ];

/// 自查项目
Property DKPIDr As dhc.pa.data.DeptKPIIndex [ SqlColumnNumber = 3, SqlFieldName = DSD_DKPIDr ];

/// 扣分系数
Property rate As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DSD_rate ];

/// 上级项目
Property parent As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DSD_parent ];

/// 自查id
Property DSchemDr As dhc.pa.data.DeptSchem [ SqlColumnNumber = 6, SqlFieldName = DSD_Dschem ];

Index SchemKPI On (DSchemDr, DKPIDr);

Index Schem On DSchemDr;

Index DKPI On DKPIDr;

Index parent On parent;

Index SchemParent On (DSchemDr, parent);

Storage Default
{
<Data name="DeptSchemDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>order</Value>
</Value>
<Value name="3">
<Value>DKPIDr</Value>
</Value>
<Value name="4">
<Value>rate</Value>
</Value>
<Value name="5">
<Value>parent</Value>
</Value>
<Value name="6">
<Value>DSchemDr</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPADeptSchemDetailD</DataLocation>
<DefaultData>DeptSchemDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPADeptSchemDetailD</IdLocation>
<IndexLocation>^DHCCJXPADeptSchemDetailI</IndexLocation>
<StreamLocation>^DHCCJXPADeptSchemDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
