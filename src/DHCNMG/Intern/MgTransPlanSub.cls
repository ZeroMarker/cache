/// creator:xbl
/// createdate:20170918
/// description:转科计划列表
Class DHCNMG.Intern.MgTransPlanSub Extends %Persistent
{

/// 转科计划记录
Property PlanDR As DHCNMG.Intern.MgTransPlan [ SqlColumnNumber = 2, SqlFieldName = Plan_DR ];

/// 行记录
Property PlanGroupDR As DHCNMG.Intern.MgTransPlanGroup [ SqlColumnNumber = 3, SqlFieldName = Plan_GroupDR ];

/// 时段 列记录
Property PlanTimeDR As DHCNMG.Intern.MgTransPlanTime [ SqlColumnNumber = 4, SqlFieldName = Plan_TimeDR ];

/// 病区
Property PlanWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 5, SqlFieldName = Plan_WardDR ];

/// 护士
Property PlanPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 6, SqlFieldName = Plan_PerDR ];

Index Plan On PlanDR;

Index PlanGroup On (PlanDR, PlanGroupDR);

Index PlanTime On (PlanDR, PlanTimeDR);

Index PlanWard On (PlanDR, PlanWardDR);

Index PlanPerson On (PlanDR, PlanPerDR);

Index Repeat On (PlanDR, PlanGroupDR, PlanTimeDR, PlanWardDR, PlanPerDR);

Storage Default
{
<Data name="MgTransPlanSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanDR</Value>
</Value>
<Value name="3">
<Value>PlanRowDR</Value>
</Value>
<Value name="4">
<Value>PlanTimeDR</Value>
</Value>
<Value name="5">
<Value>PlanWardDR</Value>
</Value>
<Value name="6">
<Value>PlanPerDR</Value>
</Value>
<Value name="7">
<Value>PlanGroupDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Intern.MgTransPlanSubD</DataLocation>
<DefaultData>MgTransPlanSubDefaultData</DefaultData>
<IdLocation>^DHCNMG.Intern.MgTransPlanSubD</IdLocation>
<IndexLocation>^DHCNMG.Intern.MgTransPlanSubI</IndexLocation>
<StreamLocation>^DHCNMG.Intern.MgTransPlanSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
