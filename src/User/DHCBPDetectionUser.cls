Class User.DHCBPDetectionUser Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPDU_RowId, SqlTableName = DHC_BP_DetectionUser, StorageStrategy = CacheStorage ]
{

Property BPDUBPDDr As User.DHCBPDetection [ SqlColumnNumber = 2, SqlFieldName = BPDU_BPD_Dr ];

Property BPDUUserDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPDU_User_Dr ];

Property BPDUUserName As %String [ SqlColumnNumber = 4, SqlFieldName = BPDU_UserName ];

Index Detection On BPDUBPDDr;

Storage CacheStorage
{
<Data name="DHCBPDetectionUserClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPDetectionUserData">
<Value name="1">
<Value>BPDUBPDDr</Value>
</Value>
<Value name="2">
<Value>BPDUUserDr</Value>
</Value>
<Value name="3">
<Value>BPDUUserName</Value>
</Value>
</Data>
<DataLocation>^DHCBPDetectionUser</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPDetectionUser</IdLocation>
<IndexLocation>^DHCBPDetectionUser(0)</IndexLocation>
<StreamLocation>^User.DHCBPDetectionUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
