/// 名称:	EMR.OP.ExtAuditLog
/// 描述:	门诊诊断证明审核日志表
/// 编写者：yejian
/// 编写日期: 2022-6-8
/// 产品组：电子病历产品组
Class EMR.OP.ExtAuditLog Extends %Persistent
{

Index IdxdocId On documentID;

Index IdxAuditUsr On AuditUser;

Index IdexAuditDate On AuditDate;

Property documentID As %Integer;

/// 操作人
Property Operator As User.SSUser;

/// 审核人
Property AuditUser As User.SSUser;

/// 审核日期
Property AuditDate As %Date;

/// 审核时间
Property AuditTime As %Time;

/// 操作IP
Property OperateMachineIP As %String(TRUNCATE = 1);

/// 状态编码（checked:审核,refused:拒绝）
Property Action As %String;

/// 状态(1:有效)
Property Status As %String;

Storage Default
{
<Data name="ExtAuditLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceId</Value>
</Value>
<Value name="3">
<Value>Operator</Value>
</Value>
<Value name="4">
<Value>AuditUser</Value>
</Value>
<Value name="5">
<Value>AuditDate</Value>
</Value>
<Value name="6">
<Value>AuditTime</Value>
</Value>
<Value name="7">
<Value>Action</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
<Value name="9">
<Value>documentID</Value>
</Value>
<Value name="10">
<Value>OperateMachineIP</Value>
</Value>
</Data>
<DataLocation>^EMR.OP.ExtAuditLogD</DataLocation>
<DefaultData>ExtAuditLogDefaultData</DefaultData>
<IdLocation>^EMR.OP.ExtAuditLogD</IdLocation>
<IndexLocation>^EMR.OP.ExtAuditLogI</IndexLocation>
<StreamLocation>^EMR.OP.ExtAuditLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
