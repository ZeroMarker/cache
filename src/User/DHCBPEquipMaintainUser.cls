Class User.DHCBPEquipMaintainUser Extends %Persistent [ ProcedureBlock, SqlRowIdName = BPEMU_RowId, SqlTableName = DHC_BP_EquipMaintainUser, StorageStrategy = CacheStorage ]
{

Property BPEMUBPEMDr As User.DHCBPEquipMaintain [ SqlColumnNumber = 2, SqlFieldName = BPEMU_BPEM_Dr ];

Property BPEMUBPEMUserDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPEMU_BPEMUser_Dr ];

Property BPEMUBPEMName As %String [ SqlColumnNumber = 4, SqlFieldName = BPEMU_BPEMName ];

Index EquipMaintain On BPEMUBPEMDr;

Storage CacheStorage
{
<Data name="DHCBPEquipMaintainUserClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPEquipMaintainUserData">
<Value name="1">
<Value>BPEMUBPEMDr</Value>
</Value>
<Value name="2">
<Value>BPEMUBPEMUserDr</Value>
</Value>
<Value name="3">
<Value>BPEMUBPEMName</Value>
</Value>
</Data>
<DataLocation>^DHCBPEquipMaintainUser</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPEquipMaintainUser</IdLocation>
<IndexLocation>^DHCBPEquipMaintainUser(0)</IndexLocation>
<StreamLocation>^User.DHCBPEquipMaintainUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
