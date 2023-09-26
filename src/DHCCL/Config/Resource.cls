/// 医护人员资源
Class DHCCL.Config.Resource Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Resource ]
{

Property Code As %String [ SqlColumnNumber = 2 ];

Property Description As %String [ SqlColumnNumber = 3 ];

Property Location As DHCCL.Config.Location [ SqlColumnNumber = 4 ];

Property CareProv As DHCCL.Config.CareProvider [ SqlColumnNumber = 5 ];

Property ExternalID As %String [ SqlColumnNumber = 6 ];

Index Loc On Location;

Index Ext On ExternalID;

Index CP On (CareProv, Location);

Index Desc On (Location, Description As Exact);

Storage Default
{
<Data name="ResourceDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Location</Value>
</Value>
<Value name="4">
<Value>CareProv</Value>
</Value>
<Value name="5">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.ResourceD</DataLocation>
<DefaultData>ResourceDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.ResourceD</IdLocation>
<IndexLocation>^DHCCL.Config.ResourceI</IndexLocation>
<StreamLocation>^DHCCL.Config.ResourceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
