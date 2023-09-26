Class User.DHCBPMessage Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPM_RowId, SqlTableName = DHC_BP_Message, StorageStrategy = CacheStorage ]
{

Property BPMBPCMDr As User.DHCBPCMessage [ SqlColumnNumber = 2, SqlFieldName = BPM_BPCM_Dr ];

Property BPMBPPatRegisterDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPM_BPPatRegister_Dr ];

Property BPMDate As %Date [ SqlColumnNumber = 4, SqlFieldName = BPM_Date ];

Property BPMTime As %Time [ SqlColumnNumber = 5, SqlFieldName = BPM_Time ];

Property BPMNote As %String [ SqlColumnNumber = 6, SqlFieldName = BPM_Note ];

Property BPMUserDr As %String [ SqlColumnNumber = 7, SqlFieldName = BPM_User_Dr ];

Index MessPatDate On (BPMBPCMDr, BPMBPPatRegisterDr As Plus, BPMDate);

Storage CacheStorage
{
<Data name="DHCBPMessageClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPMessageData">
<Value name="1">
<Value>BPMBPCMDr</Value>
</Value>
<Value name="2">
<Value>BPMBPPatRegisterDr</Value>
</Value>
<Value name="3">
<Value>BPMDate</Value>
</Value>
<Value name="4">
<Value>BPMTime</Value>
</Value>
<Value name="5">
<Value>BPMNote</Value>
</Value>
<Value name="6">
<Value>BPMUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPMessage</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPMessage</IdLocation>
<IndexLocation>^DHCBPMessage(0)</IndexLocation>
<StreamLocation>^User.DHCBPMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
