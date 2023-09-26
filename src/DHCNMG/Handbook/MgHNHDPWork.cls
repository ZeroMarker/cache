Class DHCNMG.Handbook.MgHNHDPWork Extends %Persistent
{

/// 工作计划制定人
Property HNHPlayDesDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = HNH_PlayDes_DR ];

/// 工作计划制定病区
Property HNHPlanWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = HNH_PlanWard_DR ];

/// 工作计划主题
Property HNHPlanTitle As %String(MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = HNH_PlanTitle ];

/// 工作计划
Property HNHWorkPlan As %String(MAXLEN = 2000) [ SqlColumnNumber = 5, SqlFieldName = HNH_WorkPlan ];

/// 工作计划创建日期
Property HNHCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = HNH_CreateDate ];

/// 工作计划创建时间
Property HNHCreateTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 7, SqlFieldName = HNH_CreateTime ];

///  状态(未提交N，提交Y，审核S，驳回B)
Property HNHPlanStatus As %String [ SqlColumnNumber = 8, SqlFieldName = HNH_PlanStatus ];

/// 工作计划提交日期
Property HNHSubmitDate As %Date [ SqlColumnNumber = 9, SqlFieldName = HNH_SubmitDate ];

/// 工作计划提交时间
Property HNHSubmitTime As %Time [ SqlColumnNumber = 10, SqlFieldName = HNH_SubmitTime ];

/// 审核人员
Property HNHRevDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 11, SqlFieldName = HNH_Rev_DR ];

/// 驳回操作人员
Property HNHOperDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 12, SqlFieldName = HNH_Oper_DR ];

/// 审核通过日期
Property HNHRevDate As %Date [ SqlColumnNumber = 13, SqlFieldName = HNH_RevDate ];

/// 审核通过时间
Property HNHRevTime As %Time [ SqlColumnNumber = 14, SqlFieldName = HNH_RevTime ];

/// 驳回原因
Property HNHRejectation As %String(MAXLEN = 100) [ SqlColumnNumber = 15, SqlFieldName = HNH_Rejectation ];

/// 驳回日期
Property HNHRejDate As %Date [ SqlColumnNumber = 16, SqlFieldName = HNH_RejDate ];

/// 驳回时间
Property HNHRejTime As %Time [ SqlColumnNumber = 17, SqlFieldName = HNH_RejTime ];

/// 审核通过建议
Property HNHRevIdea As %String [ SqlColumnNumber = 18, SqlFieldName = HNH_Rev_Idea ];

Index PlayDes On HNHPlayDesDR;

Index PlanWard On HNHPlanWardDR;

Index PlanTitle On HNHPlanTitle;

Index PlanDate On HNHCreateDate;

Storage Default
{
<Data name="MgHNHDPWorkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HNHPlayDesDR</Value>
</Value>
<Value name="3">
<Value>HNHPlanWardDR</Value>
</Value>
<Value name="4">
<Value>HNHPlanTitle</Value>
</Value>
<Value name="5">
<Value>HNHWorkPlan</Value>
</Value>
<Value name="6">
<Value>HNHCreateDate</Value>
</Value>
<Value name="7">
<Value>HNHCreateTime</Value>
</Value>
<Value name="8">
<Value>HNHPlanStatus</Value>
</Value>
<Value name="9">
<Value>HNHSubmitDate</Value>
</Value>
<Value name="10">
<Value>HNHSubmitTime</Value>
</Value>
<Value name="11">
<Value>HNHRevDR</Value>
</Value>
<Value name="12">
<Value>HNHOperDR</Value>
</Value>
<Value name="13">
<Value>HNHRevDate</Value>
</Value>
<Value name="14">
<Value>HNHRevTime</Value>
</Value>
<Value name="15">
<Value>HNHRejectation</Value>
</Value>
<Value name="16">
<Value>HNHRejDate</Value>
</Value>
<Value name="17">
<Value>HNHRejTime</Value>
</Value>
<Value name="18">
<Value>HNHRevIdea</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Handbook.MgHNHDPWorkD</DataLocation>
<DefaultData>MgHNHDPWorkDefaultData</DefaultData>
<IdLocation>^DHCNMG.Handbook.MgHNHDPWorkD</IdLocation>
<IndexLocation>^DHCNMG.Handbook.MgHNHDPWorkI</IndexLocation>
<StreamLocation>^DHCNMG.Handbook.MgHNHDPWorkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
