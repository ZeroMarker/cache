/// Creator:gzj
/// Date:2018-11-19
/// Description:学员助护轮转申请
Class DHCNMG.Train.MgNurTransPlan Extends %Persistent
{

Relationship ChildSub As DHCNMG.Train.MgNurTransPlanSub [ Cardinality = children, Inverse = Parref ];

/// 类型
Property TransType As %String [ SqlColumnNumber = 2, SqlFieldName = Trans_Type ];

/// 转入病区
Property TransWard As %String [ SqlColumnNumber = 3, SqlFieldName = Trans_Ward ];

/// 转入日期
Property TransDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Trans_Date ];

/// 创建人
Property CreateUser As %String [ SqlColumnNumber = 5, SqlFieldName = Create_User ];

/// 状态 【N：保存 	Y：提交	 A：审核 B：驳回】
Property TransFlag As %String [ SqlColumnNumber = 6, SqlFieldName = Trans_Flag ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$P($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = Create_Time ];

/// 审核人
Property AuditUser As %String [ SqlColumnNumber = 9, SqlFieldName = Audit_User ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 10, SqlFieldName = Audit_Date ];

/// 审核意见
Property AuditOpinion As %String [ SqlColumnNumber = 11, SqlFieldName = AuditOpinion ];

Index Type On (TransType, TransDate, TransWard);

Storage Default
{
<Data name="MgNurTransPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransType</Value>
</Value>
<Value name="3">
<Value>TransWard</Value>
</Value>
<Value name="4">
<Value>TransDate</Value>
</Value>
<Value name="5">
<Value>CreateUser</Value>
</Value>
<Value name="6">
<Value>TransFlag</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>AuditUser</Value>
</Value>
<Value name="10">
<Value>AuditDate</Value>
</Value>
<Value name="11">
<Value>AuditOpinion</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Train.MgNurTransPlanD</DataLocation>
<DefaultData>MgNurTransPlanDefaultData</DefaultData>
<IdLocation>^DHCNMG.Train.MgNurTransPlanD</IdLocation>
<IndexLocation>^DHCNMG.Train.MgNurTransPlanI</IndexLocation>
<StreamLocation>^DHCNMG.Train.MgNurTransPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
