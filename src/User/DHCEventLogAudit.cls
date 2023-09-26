Class User.DHCEventLogAudit Extends %Persistent [ SqlRowIdName = Audit_RowId, SqlTableName = DHC_EventLogAudit ]
{

Property AuditStatusDr As User.DHCAuditStatus [ SqlFieldName = Audit_Status_Dr ];

Property AuditUserDr As User.SSUser [ SqlFieldName = Audit_User_Dr ];

Property AuditDate As %Date [ SqlFieldName = Audit_Date ];

Property AuditTime As %Time [ SqlFieldName = Audit_Time ];

Property AuditNote As %String [ SqlFieldName = Audit_Note ];

Index AuditStatus On AuditStatusDr;

Storage Default
{
<Data name="DHCEventLogAuditDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AuditStatusDr</Value>
</Value>
<Value name="3">
<Value>AuditUserDr</Value>
</Value>
<Value name="4">
<Value>AuditDate</Value>
</Value>
<Value name="5">
<Value>AuditTime</Value>
</Value>
<Value name="6">
<Value>AuditNote</Value>
</Value>
</Data>
<DataLocation>^User.DHCEventLogAuditD</DataLocation>
<DefaultData>DHCEventLogAuditDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCEventLogAuditD</IdLocation>
<IndexLocation>^User.DHCEventLogAuditI</IndexLocation>
<StreamLocation>^User.DHCEventLogAuditS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
