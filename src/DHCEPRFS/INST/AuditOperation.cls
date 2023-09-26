/// 系统操作审计日志表
Class DHCEPRFS.INST.AuditOperation Extends %Persistent
{

// 用户ID

Property UserID As %String [ SqlColumnNumber = 2 ];

// 用户姓名

Property UserName As %String [ SqlColumnNumber = 3 ];

// 操作日期

Property OperateDate As %Date [ SqlColumnNumber = 4 ];

// 操作时间

Property OperateTime As %Time [ SqlColumnNumber = 5 ];

// 操作类型(LOGIN)

Property Type As %String [ SqlColumnNumber = 6 ];

// 用户IP

Property IP As %String [ SqlColumnNumber = 7 ];

// 用户机器名

Property MachineName As %String [ SqlColumnNumber = 8 ];

// 用户MAC地址

Property MacAddr As %String [ SqlColumnNumber = 9 ];

Index IdxUserID On UserID;

Index IdxType On Type;

Index IdxOperateDateTime On (OperateDate, OperateTime);

Storage Default
{
<Data name="AuditOperationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>UserName</Value>
</Value>
<Value name="4">
<Value>OperateDate</Value>
</Value>
<Value name="5">
<Value>OperateTime</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>IP</Value>
</Value>
<Value name="8">
<Value>MachineName</Value>
</Value>
<Value name="9">
<Value>MacAddr</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.AuditOperationD</DataLocation>
<DefaultData>AuditOperationDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.AuditOperationD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.AuditOperationI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.AuditOperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
