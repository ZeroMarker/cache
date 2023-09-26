Class dhc.qm.data.Plan Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Plan_rowid, SqlTableName = Plan ]
{

/// Plan_Title
Property PlanTitle As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Plan_Title ];

/// Plan_CheckStartDate
Property PlanCheckStartDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = Plan_CheckStartDate ];

/// Plan_CheckEndDate 
Property PlanCheckEndDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = Plan_CheckEndDate ];

/// Plan_TaskStartDate  
Property PlanTaskStartDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = Plan_TaskStartDate ];

/// Plan_TaskEndDate  
Property PlanTaskEndDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = Plan_TaskEndDate ];

/// Plan_QMSchemDr  以","号分割 
Property PlanQMSchemDr As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Plan_QMSchemDr ];

/// Plan_CheckUser 
Property PlanCheckUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = Plan_CheckUser ];

/// Plan_CheckDepart 以","号分割
Property PlanCheckDepart As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Plan_CheckDepart ];

/// Plan_Status  1. 已完成 0. 未完成 3.作废
Property PlanStatus As %Library.Integer [ SqlColumnNumber = 10, SqlFieldName = Plan_Status ];

/// Plan_CycleDr 格式：2015
Property PlanCycleDr As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = Plan_CycleDr ];

/// Plan_period 格式：201501
Property Planperiod As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = Plan_period ];

Index PlanCheckUser On PlanCheckUser;

Index PlanCheckStartDate On PlanCheckStartDate;

Index UserStartDate On (PlanCheckUser, PlanCheckStartDate);

Storage Default
{
<Data name="PlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanTitle</Value>
</Value>
<Value name="3">
<Value>PlanCheckStartDate</Value>
</Value>
<Value name="4">
<Value>PlanCheckEndDate</Value>
</Value>
<Value name="5">
<Value>PlanTaskStartDate</Value>
</Value>
<Value name="6">
<Value>PlanTaskEndDate</Value>
</Value>
<Value name="7">
<Value>PlanQMSchemDr</Value>
</Value>
<Value name="8">
<Value>PlanCheckUser</Value>
</Value>
<Value name="9">
<Value>PlanCheckDepart</Value>
</Value>
<Value name="10">
<Value>PlanStatus</Value>
</Value>
<Value name="11">
<Value>PlanCycleDr</Value>
</Value>
<Value name="12">
<Value>Planperiod</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMPlanD</DataLocation>
<DefaultData>PlanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMPlanD</IdLocation>
<IndexLocation>^DHCCJXQMPlanI</IndexLocation>
<StreamLocation>^DHCCJXQMPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
