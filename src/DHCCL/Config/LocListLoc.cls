/// 科室列表关联的科室
Class DHCCL.Config.LocListLoc Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = LocListLoc ]
{

Property LocList As DHCCL.Config.LocationList [ Required, SqlColumnNumber = 2 ];

Property Location As DHCCL.Config.Location [ Required, SqlColumnNumber = 3 ];

Property Hospital As DHCCL.Config.Hospital [ SqlColumnNumber = 4 ];

Property ExternalID As %String [ SqlColumnNumber = 5 ];

Index List On LocList;

Index Hosp On Hospital;

Index Ext On ExternalID;

Storage Default
{
<Data name="LocListLocDefaultData">
<Value name="1">
<Value>LocList</Value>
</Value>
<Value name="2">
<Value>Location</Value>
</Value>
<Value name="3">
<Value>Hospital</Value>
</Value>
<Value name="4">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.LocListLocD</DataLocation>
<DefaultData>LocListLocDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.LocListLocD</IdLocation>
<IndexLocation>^DHCCL.Config.LocListLocI</IndexLocation>
<StreamLocation>^DHCCL.Config.LocListLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
