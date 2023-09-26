Class DHCINM.Intern.MgTransPlanTime Extends %Persistent
{

/// 转科计划记录
Property PlanDR As DHCINM.Intern.MgTransPlan [ SqlColumnNumber = 2, SqlFieldName = Plan_DR ];

/// 开始日期
Property PlanStDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Plan_StDate ];

/// 结束日期
Property PlanEndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Plan_EndDate ];

Index Plan On PlanDR;

Index date On (PlanDR, PlanStDate);

Storage Default
{
<Data name="MgTransPlanTimeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanDR</Value>
</Value>
<Value name="3">
<Value>PlanStDate</Value>
</Value>
<Value name="4">
<Value>PlanEndDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Intern.MgTransPlanTimeD</DataLocation>
<DefaultData>MgTransPlanTimeDefaultData</DefaultData>
<IdLocation>^DHCINM.Intern.MgTransPlanTimeD</IdLocation>
<IndexLocation>^DHCINM.Intern.MgTransPlanTimeI</IndexLocation>
<StreamLocation>^DHCINM.Intern.MgTransPlanTimeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
