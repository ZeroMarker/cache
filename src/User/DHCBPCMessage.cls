Class User.DHCBPCMessage Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCM_RowId, SqlTableName = DHC_BPC_Message, StorageStrategy = CacheStorage ]
{

Property BPCMCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCM_Code ];

Property BPCMDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCM_Desc ];

Property BPCMSourceType As %String [ SqlColumnNumber = 4, SqlFieldName = BPCM_SourceType ];

Property BPCMReceiveType As %String(DISPLAYLIST = ",Location,Patient", MAXLEN = 8, SELECTIVITY = "33.3333%", VALUELIST = ",L,P") [ SqlColumnNumber = 5, SqlFieldName = BPCM_ReceiveType ];

Property BPCMFreqMonth As %Float [ SqlColumnNumber = 6, SqlFieldName = BPCM_FreqMonth ];

Property BPCMAheadDay As %Float [ SqlColumnNumber = 7, SqlFieldName = BPCM_AheadDay ];

Property BPCMFixedMonth As %Float [ SqlColumnNumber = 8, SqlFieldName = BPCM_FixedMonth ];

Property BPCMBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 9, SqlFieldName = BPCM_BPPatRegister_Dr ];

Index CodePat On (BPCMCode As Exact, BPCMBPPatRegisterDr As Plus);

Storage CacheStorage
{
<Data name="DHCBPCMessageClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCMessageData">
<Value name="1">
<Value>BPCMCode</Value>
</Value>
<Value name="2">
<Value>BPCMDesc</Value>
</Value>
<Value name="3">
<Value>BPCMSourceType</Value>
</Value>
<Value name="4">
<Value>BPCMReceiveType</Value>
</Value>
<Value name="5">
<Value>BPCMFreqMonth</Value>
</Value>
<Value name="6">
<Value>BPCMAheadDay</Value>
</Value>
<Value name="7">
<Value>BPCMFixedMonth</Value>
</Value>
<Value name="8">
<Value>BPCMBPPatRegisterDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("Message")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("Message")</IdLocation>
<IndexLocation>^DHCBPC("Message",0)</IndexLocation>
<StreamLocation>^User.DHCBPCMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
