/// 基础数据的院区关联
Class User.DHCBPCDataAttribution Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCAt_RowId, SqlTableName = DHC_BPC_DataAttribution, StorageStrategy = CacheStorage ]
{

/// 院区ID
Property HospitalID As %String [ Required, SqlColumnNumber = 2, SqlFieldName = BPCAt_HospitalId ];

/// 类描述
Property TableName As %String [ SqlColumnNumber = 3, SqlFieldName = BPCAt_TableName ];

/// 数据ID
Property DataRowID As %String [ SqlColumnNumber = 4, SqlFieldName = BPCAt_DataRowID ];

Index IHospital On HospitalID;

Index IData On (TableName, DataRowID);

Storage CacheStorage
{
<Data name="DHCBPCDataAttributionClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCDataAttributionDefaultData">
<Value name="1">
<Value>HospitalID</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>DataRowID</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("DataAttribution")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("DataAttribution")</IdLocation>
<IndexLocation>^User.DHCBPCDataAttributionI</IndexLocation>
<StreamLocation>^User.DHCBPCDataAttributionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
