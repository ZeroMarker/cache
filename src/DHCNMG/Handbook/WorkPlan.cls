Class DHCNMG.Handbook.WorkPlan Extends %Persistent [ SqlTableName = WorkPlan ]
{

/// 工作计划类型(周工作：W；月工作：M；季度工作：Q；年工作：Y)
Property WorkPlanType As %String [ SqlColumnNumber = 2, SqlFieldName = WorkPlanType ];

/// 工作计划日期
Property WorkPlanDate As %String [ SqlColumnNumber = 3, SqlFieldName = WorkPlanDate ];

/// 创建人
Property Creater As DHCNMG.HR.MgPersons [ SqlColumnNumber = 4, SqlFieldName = Creater ];

/// 病区
Property WardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 5, SqlFieldName = WardDR ];

/// 工作计划
Property WorkPlan As %String(MAXLEN = 10000) [ SqlColumnNumber = 6, SqlFieldName = WorkPlan ];

/// 完成情况	
Property Completion As %String(MAXLEN = 10000) [ SqlColumnNumber = 7, SqlFieldName = Completion ];

/// 备注
Property Remarks As %String(MAXLEN = 10000) [ SqlColumnNumber = 8, SqlFieldName = Remarks ];

/// 状态【保存N 提交Y 审核S 驳回B】	
Property Status As %String [ SqlColumnNumber = 9, SqlFieldName = Status ];

/// 提交日期	
Property SubmitDate As %Date [ SqlColumnNumber = 10, SqlFieldName = SubmitDate ];

/// 提交时间	
Property SubmitTime As %Time [ SqlColumnNumber = 11, SqlFieldName = SubmitTime ];

/// 审核日期	
Property CheckDate As %Date [ SqlColumnNumber = 12, SqlFieldName = CheckDate ];

/// 审核时间	
Property CheckTime As %Time [ SqlColumnNumber = 13, SqlFieldName = CheckTime ];

/// 驳回日期	
Property RejectDate As %Date [ SqlColumnNumber = 14, SqlFieldName = RejectDate ];

/// 驳回时间	
Property RejectTime As %Time [ SqlColumnNumber = 15, SqlFieldName = RejectTime ];

/// 创建日期	
Property CreatDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 16, SqlFieldName = CreatDate ];

/// 创建时间	
Property CreatTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 17, SqlFieldName = CreatTime ];

/// 驳回原因	
Property RejectOpinion As %String [ SqlColumnNumber = 18, SqlFieldName = RejectOpinion ];

/// 驳回人 
Property Rejector As DHCNMG.HR.MgPersons [ SqlColumnNumber = 19, SqlFieldName = Rejector ];

/// 审核意见	
Property CheckOpinion As %String [ SqlColumnNumber = 20, SqlFieldName = CheckOpinion ];

/// 审核人	
Property Checker As DHCNMG.HR.MgPersons [ SqlColumnNumber = 21, SqlFieldName = Checker ];

Index PlanDate On CreatDate;

Storage Default
{
<Data name="WorkPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkPlanType</Value>
</Value>
<Value name="3">
<Value>WorkPlanDate</Value>
</Value>
<Value name="4">
<Value>Creater</Value>
</Value>
<Value name="5">
<Value>WardDR</Value>
</Value>
<Value name="6">
<Value>WorkPlan</Value>
</Value>
<Value name="7">
<Value>Completion</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>SubmitDate</Value>
</Value>
<Value name="11">
<Value>SubmitTime</Value>
</Value>
<Value name="12">
<Value>CheckDate</Value>
</Value>
<Value name="13">
<Value>CheckTime</Value>
</Value>
<Value name="14">
<Value>RejectDate</Value>
</Value>
<Value name="15">
<Value>RejectTime</Value>
</Value>
<Value name="16">
<Value>CreatDate</Value>
</Value>
<Value name="17">
<Value>CreatTime</Value>
</Value>
<Value name="18">
<Value>RejectOpinion</Value>
</Value>
<Value name="19">
<Value>Rejector</Value>
</Value>
<Value name="20">
<Value>CheckOpinion</Value>
</Value>
<Value name="21">
<Value>Checker</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Handbook.WorkPlanD</DataLocation>
<DefaultData>WorkPlanDefaultData</DefaultData>
<IdLocation>^DHCNMG.Handbook.WorkPlanD</IdLocation>
<IndexLocation>^DHCNMG.Handbook.WorkPlanI</IndexLocation>
<StreamLocation>^DHCNMG.Handbook.WorkPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
