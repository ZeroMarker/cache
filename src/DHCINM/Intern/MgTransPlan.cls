Class DHCINM.Intern.MgTransPlan Extends %Persistent
{

/// 批次编号
Property PlanCode As %String [ SqlColumnNumber = 2, SqlFieldName = Plan_Code ];

/// 批次名称
Property PlanDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Plan_Desc ];

/// 状态
Property PlanStatus As %String [ SqlColumnNumber = 4, SqlFieldName = Plan_Status ];

/// 创建人
Property PlanCrtUser As %String [ SqlColumnNumber = 5, SqlFieldName = Plan_CrtUser ];

/// 创建日期
Property PlanCrtDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Plan_CrtDate ];

/// 批次实习生
Property PlanIntern As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = Plan_Intern ];

/// 开始日期
Property PlanStDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Plan_StDate ];

/// 结束日期
Property PlanEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Plan_EndDate ];

Index member On PlanIntern;

Storage Default
{
<Data name="MgTransPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanCode</Value>
</Value>
<Value name="3">
<Value>PlanDesc</Value>
</Value>
<Value name="4">
<Value>PlanStatus</Value>
</Value>
<Value name="5">
<Value>PlanCrtUser</Value>
</Value>
<Value name="6">
<Value>PlanCrtDate</Value>
</Value>
<Value name="7">
<Value>PlanIntern</Value>
</Value>
<Value name="8">
<Value>PlanStDate</Value>
</Value>
<Value name="9">
<Value>PlanEndDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Intern.MgTransPlanD</DataLocation>
<DefaultData>MgTransPlanDefaultData</DefaultData>
<IdLocation>^DHCINM.Intern.MgTransPlanD</IdLocation>
<IndexLocation>^DHCINM.Intern.MgTransPlanI</IndexLocation>
<StreamLocation>^DHCINM.Intern.MgTransPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
