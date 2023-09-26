Class User.DHCCLCMessage Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCM_RowId, SqlTableName = DHC_CLC_Message, StorageStrategy = CacheStorage ]
{

Property CLCMCtlocDr As %String [ SqlColumnNumber = 2, SqlFieldName = CLCM_Ctloc_Dr ];

Property CLCMUserGroupDr As %String [ SqlColumnNumber = 3, SqlFieldName = CLCM_UserGroup_Dr ];

Property CLCMClientIP As %String [ SqlColumnNumber = 4, SqlFieldName = CLCM_ClientIP ];

Property CLCMLastReceiveDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CLCM_LastReceiveDate ];

Property CLCMLastReceiveTime As %Time [ SqlColumnNumber = 6, SqlFieldName = CLCM_LastReceiveTime ];

Index Ctloc On CLCMCtlocDr As Exact;

Storage CacheStorage
{
<Data name="DHCCLCMessageClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCMessageDefaultData">
<Value name="1">
<Value>CLCMCtlocDr</Value>
</Value>
<Value name="2">
<Value>CLCMUserGroupDr</Value>
</Value>
<Value name="3">
<Value>CLCMClientIP</Value>
</Value>
<Value name="4">
<Value>CLCMLastReceiveDate</Value>
</Value>
<Value name="5">
<Value>CLCMLastReceiveTime</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("Message")</DataLocation>
<DefaultData>DHCCLCMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("Message")</IdLocation>
<IndexLocation>^DHCCLC("Message",0)</IndexLocation>
<StreamLocation>^User.DHCCLCMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
