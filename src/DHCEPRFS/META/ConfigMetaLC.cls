Class DHCEPRFS.META.ConfigMetaLC Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxTableName On TableName [ Unique ];

Property TableName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property ConfigName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property ClassName As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property QueryFunction As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property IsActive As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Property Fields As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="ConfigMetaLCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>ConfigName</Value>
</Value>
<Value name="4">
<Value>ClassName</Value>
</Value>
<Value name="5">
<Value>QueryFunction</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>Fields</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ConfigMetaLCD</DataLocation>
<DefaultData>ConfigMetaLCDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.ConfigMetaLCD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ConfigMetaLCI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ConfigMetaLCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
