/// 数据对照表
Class CIS.AN.DataMapping Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DataMapping ]
{

/// 数据表
Property TableName As %String [ Required, SqlColumnNumber = 2 ];

/// 实例ID
Property InstanceID As %String [ Required, SqlColumnNumber = 3 ];

/// 外部系统(OPApp,AIS,HIS,LIS,PIS)
Property ExternalSystem As %String [ Required, SqlColumnNumber = 4 ];

/// 外部ID
Property ExternalID As %String [ Required, SqlColumnNumber = 5 ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6 ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 7 ];

Index Ext On (TableName, ExternalSystem, ExternalID, InstanceID);

Index Ins On (TableName, InstanceID, ExternalSystem, ExternalID);

Storage Default
{
<Data name="DataMappingDefaultData">
<Value name="1">
<Value>TableName</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>ExternalSystem</Value>
</Value>
<Value name="4">
<Value>ExternalID</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.DataMappingD</DataLocation>
<DefaultData>DataMappingDefaultData</DefaultData>
<IdLocation>^CIS.AN.DataMappingD</IdLocation>
<IndexLocation>^CIS.AN.DataMappingI</IndexLocation>
<StreamLocation>^CIS.AN.DataMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
