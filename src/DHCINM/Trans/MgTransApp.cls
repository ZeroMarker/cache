/// Creater:wangcc
/// Descriptions:调配申请表
/// Date:2020-07-22
Class DHCINM.Trans.MgTransApp Extends %Persistent
{

/// 申请日期
Property AppDate As %Date [ SqlColumnNumber = 2, SqlFieldName = App_Date ];

/// 薪酬说明
Property TransNurSalary As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = Trans_NurSalary ];

/// 转入病区
Property TransInDep As %String [ SqlColumnNumber = 4, SqlFieldName = Trans_InDep ];

/// 申请人数
Property TransCount As %Integer [ SqlColumnNumber = 5, SqlFieldName = Trans_Count ];

/// 状态【N:未提交 Y: 待审核  A：审核通过 HA: 提请护理部审核 B：驳回】
Property TransStatus As %String [ SqlColumnNumber = 6, SqlFieldName = Trans_Status ];

/// 计划开始日期
Property PlanStDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Plan_StDate ];

/// 计划结束日期
Property PlanEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Plan_EndDate ];

/// 申请人
Property CreateUser As %String [ SqlColumnNumber = 9, SqlFieldName = Create_User ];

/// 申请原因
Property TransReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = Trans_Reason ];

/// 申请护士条件
Property TransNurCondition As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = Trans_NurCondition ];

/// 备注
Property Remark As %String(MAXLEN = 1000) [ SqlColumnNumber = 12, SqlFieldName = Trans_Remark ];

/// 预计天数
Property PlanDays As %String [ SqlColumnNumber = 13, SqlFieldName = Trans_PlanDays ];

Storage Default
{
<Data name="MgTransAppDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppDate</Value>
</Value>
<Value name="3">
<Value>TransNurSalary</Value>
</Value>
<Value name="4">
<Value>TransInDep</Value>
</Value>
<Value name="5">
<Value>TransCount</Value>
</Value>
<Value name="6">
<Value>TransStatus</Value>
</Value>
<Value name="7">
<Value>PlanStDate</Value>
</Value>
<Value name="8">
<Value>PlanEndDate</Value>
</Value>
<Value name="9">
<Value>CreateUser</Value>
</Value>
<Value name="10">
<Value>TransReason</Value>
</Value>
<Value name="11">
<Value>TransNurCondition</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
<Value name="13">
<Value>PlanDays</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Trans.MgTransAppD</DataLocation>
<DefaultData>MgTransAppDefaultData</DefaultData>
<IdLocation>^DHCINM.Trans.MgTransAppD</IdLocation>
<IndexLocation>^DHCINM.Trans.MgTransAppI</IndexLocation>
<StreamLocation>^DHCINM.Trans.MgTransAppS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
