Class dhc.pa.data.SchemPeridRecChkProc Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SPRC_Rowid, SqlTableName = Schem_Perid_RecChkProc ]
{

//考核方案ID

Property SPRCShemDr As dhc.pa.data.SchemPeridRec [ SqlColumnNumber = 2, SqlFieldName = SPRC_ShemPeridRecDR ];

//审批人

Property SPRCChercker As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = SPRC_Chercker ];

//审批时间

Property SPRCDateTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = SPRC_DateTime ];

//0 未提交 10 审核未通过  20 已提交  30 审核通过 60 发布

Property SPRCChkResult As %Library.Integer [ SqlColumnNumber = 5, SqlFieldName = SPRC_ChkResult ];

//审批功能描述

Property SPRCChkProcDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SPRC_ChkProcDesc ];

//审批意见描述

Property SPRCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SPRC_Desc ];

//审批人科室

Property SPRCDeptDR As %Library.Integer [ SqlColumnNumber = 8, SqlFieldName = SPRC_DeptDR ];

//审批业务分类 对照绩效单元方案主表

Property SPRCChkType As dhc.pa.data.UnitResult [ SqlColumnNumber = 9, SqlFieldName = SPRC_ChkType ];

Storage Default
{
<Data name="SchemPeridRecChkProcDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SPRCShemDr</Value>
</Value>
<Value name="3">
<Value>SPRCChercker</Value>
</Value>
<Value name="4">
<Value>SPRCDateTime</Value>
</Value>
<Value name="5">
<Value>SPRCChkResult</Value>
</Value>
<Value name="6">
<Value>SPRCChkProcDesc</Value>
</Value>
<Value name="7">
<Value>SPRCDesc</Value>
</Value>
<Value name="8">
<Value>SPRCDeptDR</Value>
</Value>
<Value name="9">
<Value>SPRCChkType</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPASchemPeridRecChkProcD</DataLocation>
<DefaultData>SchemPeridRecChkProcDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPASchemPeridRecChkProcD</IdLocation>
<IndexLocation>^DHCCJXPASchemPeridRecChkProcI</IndexLocation>
<StreamLocation>^DHCCJXPASchemPeridRE813S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
