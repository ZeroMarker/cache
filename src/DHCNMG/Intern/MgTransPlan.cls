/// creator:xbl
/// createdate:20170918
/// description:转科计划列表
Class DHCNMG.Intern.MgTransPlan Extends %Persistent
{

/// 申请单号
Property PlanCode As %String [ SqlColumnNumber = 2, SqlFieldName = Plan_Code ];

/// 转科名
Property PlanDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Plan_Desc ];

/// 备注
Property PlanRemarks As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = Plan_Remarks ];

/// 状态
Property PlanStatus As %String [ SqlColumnNumber = 5, SqlFieldName = Plan_Status ];

/// 创建人
Property PlanCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 6, SqlFieldName = Plan_CrtUser ];

/// 创建日期
Property PlanCrtDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Plan_CrtDate ];

/// 创建时间
Property PlanCrtTime As %Time [ SqlColumnNumber = 8, SqlFieldName = Plan_CrtTime ];

/// 最后修改人
Property PlanEditUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 9, SqlFieldName = Plan_EditUser ];

/// 修改日期
Property PlanEditDate As %Date [ SqlColumnNumber = 10, SqlFieldName = Plan_EditDate ];

/// 修改时间
Property PlanEditTime As %Time [ SqlColumnNumber = 11, SqlFieldName = Plan_EditTime ];

Index Code On PlanCode;

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
<Value>PlanRemarks</Value>
</Value>
<Value name="5">
<Value>PlanStatus</Value>
</Value>
<Value name="6">
<Value>PlanCrtUser</Value>
</Value>
<Value name="7">
<Value>PlanCrtDate</Value>
</Value>
<Value name="8">
<Value>PlanCrtTime</Value>
</Value>
<Value name="9">
<Value>PlanEditUser</Value>
</Value>
<Value name="10">
<Value>PlanEditDate</Value>
</Value>
<Value name="11">
<Value>PlanEditTime</Value>
</Value>
<Value name="12">
<Value>PlanStopDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Intern.MgTransPlanD</DataLocation>
<DefaultData>MgTransPlanDefaultData</DefaultData>
<IdLocation>^DHCNMG.Intern.MgTransPlanD</IdLocation>
<IndexLocation>^DHCNMG.Intern.MgTransPlanI</IndexLocation>
<StreamLocation>^DHCNMG.Intern.MgTransPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
