Class User.DHCBPVascularAccessPicture Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BP_VascularAccessPicture, StorageStrategy = CacheStorage ]
{

Property BPVPBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPVP_BPPatRegister_Dr ];

Property BPVPVascularAccessDr As User.DHCBPVascularAccess [ SqlColumnNumber = 3, SqlFieldName = BPVP_VascularAccess_Dr ];

Property BPVPImage As %GlobalCharacterStream [ SqlColumnNumber = 4, SqlFieldName = BPVP_Image ];

Property BPVPIfActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = BPVP_IfActive ];

Property BPVPStartDate As %Date [ SqlColumnNumber = 6, SqlFieldName = BPVP_StartDate ];

Property BPVPStartTime As %Time [ SqlColumnNumber = 7, SqlFieldName = BPVP_StartTime ];

Property BPVPUpdateUserDr As %String [ SqlColumnNumber = 8, SqlFieldName = BPVP_UpdateUser_Dr ];

Property BPVPNote As %String [ SqlColumnNumber = 9, SqlFieldName = BPVP_Note ];

Index Register On BPVPBPPatRegisterDr As Exact;

Storage CacheStorage
{
<Data name="DHCBPVascularAccessPictureClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPVascularAccessPictureDefaultData">
<Value name="1">
<Value>BPVPBPPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPVPVascularAccessDr</Value>
</Value>
<Value name="3">
<Value>BPVPImage</Value>
</Value>
<Value name="4">
<Value>BPVPIfActive</Value>
</Value>
<Value name="5">
<Value>BPVPStartDate</Value>
</Value>
<Value name="6">
<Value>BPVPStartTime</Value>
</Value>
<Value name="7">
<Value>BPVPUpdateUserDr</Value>
</Value>
<Value name="8">
<Value>BPVPNote</Value>
</Value>
</Data>
<DataLocation>^DHCBPVascularAccessPicture</DataLocation>
<DefaultData>DHCBPVascularAccessPictureDefaultData1</DefaultData>
<IdLocation>^DHCBPVascularAccessPicture</IdLocation>
<IndexLocation>^DHCBPVascularAccessPicture(0)</IndexLocation>
<StreamLocation>^User.DHCBPVascularAccessPicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
