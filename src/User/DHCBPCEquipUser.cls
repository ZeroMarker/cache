Class User.DHCBPCEquipUser Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_EquipUser, StorageStrategy = CacheStorage ]
{

Property BPCEUBPCEDr As User.DHCBPCEquip [ SqlColumnNumber = 2, SqlFieldName = BPCEU_BPCE_Dr ];

Property BPCEUType As %String(DISPLAYLIST = ",Installer,Keeper", MAXLEN = 9, SELECTIVITY = "33.3333%", VALUELIST = ",I,K") [ SqlColumnNumber = 3, SqlFieldName = BPCEU_Type ];

Property BPCEUUserDr As %String [ SqlColumnNumber = 4, SqlFieldName = BPCEU_User_Dr ];

Property BPCEUUserName As %String [ SqlColumnNumber = 5, SqlFieldName = BPCEU_UserName ];

Property BPCEUDate As %Date [ SqlColumnNumber = 6, SqlFieldName = BPCEU_Date ];

Property BPCEUTime As %Time [ SqlColumnNumber = 7, SqlFieldName = BPCEU_Time ];

Index Equip On BPCEUBPCEDr;

Storage CacheStorage
{
<Data name="DHCBPCEquipUserClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCEquipUserData">
<Value name="1">
<Value>BPCEUBPCEDr</Value>
</Value>
<Value name="2">
<Value>BPCEUType</Value>
</Value>
<Value name="3">
<Value>BPCEUUserDr</Value>
</Value>
<Value name="4">
<Value>BPCEUUserName</Value>
</Value>
<Value name="5">
<Value>BPCEUDate</Value>
</Value>
<Value name="6">
<Value>BPCEUTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPCEquipUser</DataLocation>
<DefaultData>DHCBPCEquipUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPCEquipUser</IdLocation>
<IndexLocation>^DHCBPCEquipUser(0)</IndexLocation>
<StreamLocation>^User.DHCBPCEquipUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
