Class DHCINM.Intern.MgTransPlanSub Extends %Persistent
{

/// 转科计划记录
Property PlanDR As DHCINM.Intern.MgTransPlan [ SqlColumnNumber = 2, SqlFieldName = Plan_DR ];

/// 行记录
Property PlanGroupDR As DHCINM.Intern.MgTransPlanGroup [ SqlColumnNumber = 3, SqlFieldName = Plan_GroupDR ];

/// 时段 列记录
Property PlanTimeDR As DHCINM.Intern.MgTransPlanTime [ SqlColumnNumber = 4, SqlFieldName = Plan_TimeDR ];

/// 病区
Property PlanWardDR As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 5, SqlFieldName = Plan_WardDR ];

/// 实习生
Property PlanPerDR As %String [ SqlColumnNumber = 6, SqlFieldName = Plan_PerDR ];

Index Plan On PlanDR;

Index PlanGroup On (PlanDR, PlanGroupDR);

Index PlanTime On (PlanDR, PlanTimeDR);

Index PlanWard On (PlanDR, PlanWardDR);

Index WardTime On (PlanWardDR, PlanTimeDR);

Index PlanPerson On (PlanDR, PlanPerDR);

Index PerTime On (PlanDR, PlanGroupDR, PlanTimeDR, PlanPerDR);

Index Repeat On (PlanDR, PlanGroupDR, PlanTimeDR, PlanWardDR, PlanPerDR);

Index WardGroup On (PlanWardDR, PlanGroupDR);

Index ssid On PlanPerDR;

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
<Value>PlanGroupDR</Value>
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
</Data>
<DataLocation>^DHCINM.Intern.MgTransPlanSubD</DataLocation>
<DefaultData>MgTransPlanSubDefaultData</DefaultData>
<IdLocation>^DHCINM.Intern.MgTransPlanSubD</IdLocation>
<IndexLocation>^DHCINM.Intern.MgTransPlanSubI</IndexLocation>
<StreamLocation>^DHCINM.Intern.MgTransPlanSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
