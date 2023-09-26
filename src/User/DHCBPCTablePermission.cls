/// 基础数据的多院区权限类型
Class User.DHCBPCTablePermission Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCTab_RowId, SqlTableName = DHC_BPC_TablePermission, StorageStrategy = CacheStorage ]
{

/// 类名
Property TableName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = BPCTab_Name ];

/// 类描述
Property TableDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCTab_Desc ];

/// 权限类型
Property Permission As %String(DISPLAYLIST = ",公有,私有,管控", VALUELIST = ",Public,Private,Control") [ Required, SqlColumnNumber = 4, SqlFieldName = BPCTab_Permission ];

Index IPermission On (TableName, Permission);

Storage CacheStorage
{
<Data name="DHCBPCTablePermissionClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCTablePermissionDefaultData">
<Value name="1">
<Value>TableName</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Permission</Value>
</Value>
</Data>
<Data name="DataMaster">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>TableDesc</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("TablePermission")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("TablePermission")</IdLocation>
<IndexLocation>^User.DHCBPCTablePermissionI</IndexLocation>
<StreamLocation>^User.DHCBPCTablePermissionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
