Class dhc.pa.data.SchemPeridRec Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SPR_rowid, SqlTableName = Schem_Perid_Rec ]
{

//战略ID

Property SPRparRef As dhc.pa.data.Stratagem [ SqlColumnNumber = 2, SqlFieldName = SPR_parRef ];

//应用系统号 1:全院 2：科室  3：护理  4：医疗  5：个人

Property SPRappSysDr As %Library.Integer [ SqlColumnNumber = 3, SqlFieldName = SPR_appSysDr ];

//考核方案ID

Property SPRShemDr As dhc.pa.data.Schem [ SqlColumnNumber = 4, SqlFieldName = SPR_schemDr ];

//考核期间

Property SPRperiod As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SPR_period ];

//审批人

Property SPRauditDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = SPR_auditDr ];

//审批时间

Property SPRauditDate As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = SPR_auditDate ];

//0 未提交 10 审核未通过  20 已提交  30 审核通过 60 发布

Property SPRauditState As %Library.Integer [ SqlColumnNumber = 8, SqlFieldName = SPR_auditState ];

//审批意见描述

Property SPRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SPR_Desc ];

Storage Default
{
<Data name="SchemPeridRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SPRparRef</Value>
</Value>
<Value name="3">
<Value>SPRappSysDr</Value>
</Value>
<Value name="4">
<Value>SPRShemDr</Value>
</Value>
<Value name="5">
<Value>SPRperiod</Value>
</Value>
<Value name="6">
<Value>SPRauditDr</Value>
</Value>
<Value name="7">
<Value>SPRauditDate</Value>
</Value>
<Value name="8">
<Value>SPRauditState</Value>
</Value>
<Value name="9">
<Value>SPRDesc</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPASchemPeridRecD</DataLocation>
<DefaultData>SchemPeridRecDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPASchemPeridRecD</IdLocation>
<IndexLocation>^DHCCJXPASchemPeridRecI</IndexLocation>
<StreamLocation>^dhc.pa.data.SchemPeridRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
