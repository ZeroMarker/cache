Class User.DHCCLMessage Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLM_RowId, SqlTableName = DHC_CL_Message, StorageStrategy = CacheStorage ]
{

Property CLMCtlocDr As %String [ SqlColumnNumber = 2, SqlFieldName = CLM_Ctloc_Dr ];

Property CLMUserGroupDr As %String [ SqlColumnNumber = 3, SqlFieldName = CLM_UserGroup_Dr ];

Property CLMClientIP As %String [ SqlColumnNumber = 4, SqlFieldName = CLM_ClientIP ];

Property CLMNote As %String [ SqlColumnNumber = 5, SqlFieldName = CLM_Note ];

Property CLMSource As %String [ SqlColumnNumber = 6, SqlFieldName = CLM_Source ];

Property CLMIfSent As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = CLM_IfSent ];

Property CLMType As %String [ SqlColumnNumber = 8, SqlFieldName = CLM_Type ];

Property CLMDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CLM_Date ];

Property CLMTime As %Time [ SqlColumnNumber = 10, SqlFieldName = CLM_Time ];

Property CLMUserDr As %String [ SqlColumnNumber = 11, SqlFieldName = CLM_User_Dr ];

Index CtlocDate On (CLMCtlocDr As Exact, CLMDate As Exact);

Storage CacheStorage
{
<Data name="DHCCLMessageClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLMessageDefaultData">
<Value name="1">
<Value>CLMCtlocDr</Value>
</Value>
<Value name="2">
<Value>CLMUserGroupDr</Value>
</Value>
<Value name="3">
<Value>CLMClientIP</Value>
</Value>
<Value name="4">
<Value>CLMNote</Value>
</Value>
<Value name="5">
<Value>CLMSource</Value>
</Value>
<Value name="6">
<Value>CLMIfSent</Value>
</Value>
<Value name="7">
<Value>CLMType</Value>
</Value>
<Value name="8">
<Value>CLMDate</Value>
</Value>
<Value name="9">
<Value>CLMTime</Value>
</Value>
<Value name="10">
<Value>CLMUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCCLMessage</DataLocation>
<DefaultData>DHCCLMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLMessage</IdLocation>
<IndexLocation>^DHCCLMessage(0)</IndexLocation>
<StreamLocation>^User.DHCCLMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
