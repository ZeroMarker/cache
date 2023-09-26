/// 外部审核业务记录表
Class EMRinstance.ExtAuditLog Extends %Persistent
{

Index IdxInsId On InstanceId;

Index IdxAuditUsr On AuditUser;

Index IdexAuditDate On AuditDate;

Property InstanceId As %String;

/// 操作人
Property Operator As %String;

/// 审核人
Property AuditUser As %String;

Property AuditDate As %Date;

Property AuditTime As %Time;

Property Action As %String;

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
<Value>AuditUser</Value>
</Value>
<Value name="4">
<Value>AuditDate</Value>
</Value>
<Value name="5">
<Value>AuditTime</Value>
</Value>
<Value name="6">
<Value>Operator</Value>
</Value>
<Value name="7">
<Value>Action</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.ExtAuditLogD</DataLocation>
<DefaultData>ExtAuditLogDefaultData</DefaultData>
<IdLocation>^DHCEMRI.ExtAuditLogD</IdLocation>
<IndexLocation>^DHCEMRI.ExtAuditLogI</IndexLocation>
<StreamLocation>^DHCEMRI.ExtAuditLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
