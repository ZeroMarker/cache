/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 药物临床试验严重不良事件报告-状态改变表
Class User.DHCDocPilotSAEStatus Extends (%Persistent, User.Abstract)
{

Relationship SParRef As User.DHCDocPilotSAE [ Cardinality = parent, Inverse = ChildStatus, Required, SqlFieldName = S_ParRef ];

/// 状态
Property SStatus As %String [ SqlColumnNumber = 2, SqlFieldName = S_Status ];

/// 审核科室
Property SAuditLoc As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = S_AuditLoc ];

/// 审核人
Property SAuditUser As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = S_AuditUser ];

/// 审核日期
Property SAuditDate As %Date [ SqlColumnNumber = 5, SqlFieldName = S_AuditDate ];

/// 审核时间
Property SAuditTime As %Time [ SqlColumnNumber = 6, SqlFieldName = S_AuditTime ];

/// 添加人
Property SAddUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = S_AddUser ];

/// 添加日期
Property SAddDate As %Date [ SqlColumnNumber = 8, SqlFieldName = S_AddDate ];

/// 添加时间
Property SAddTime As %Time [ SqlColumnNumber = 9, SqlFieldName = S_AddTime ];

/// 备注
Property SNote As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = S_Note ];

/// 审核人安全组
Property SAuditGroup As User.SSGroup [ SqlColumnNumber = 11, SqlFieldName = S_AuditGroup ];

Index Status On SStatus As Exact;

Storage Default
{
<Data name="DHCDocPilotSAEStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SStatus</Value>
</Value>
<Value name="3">
<Value>SAuditLoc</Value>
</Value>
<Value name="4">
<Value>SAuditUser</Value>
</Value>
<Value name="5">
<Value>SAuditDate</Value>
</Value>
<Value name="6">
<Value>SAuditTime</Value>
</Value>
<Value name="7">
<Value>SAddUser</Value>
</Value>
<Value name="8">
<Value>SAddDate</Value>
</Value>
<Value name="9">
<Value>SAddTime</Value>
</Value>
<Value name="10">
<Value>SNote</Value>
</Value>
<Value name="11">
<Value>SAuditGroup</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildStatus")</DataLocation>
<DefaultData>DHCDocPilotSAEStatusDefaultData</DefaultData>
<IdLocation>^User.DHCDocPilotSAEC("ChildStatus")</IdLocation>
<IndexLocation>^User.DHCDocPilotSAEStatusI</IndexLocation>
<StreamLocation>^User.DHCDocPilotSAEStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
