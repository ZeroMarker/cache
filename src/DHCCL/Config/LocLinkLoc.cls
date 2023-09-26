/// 关联科室
Class DHCCL.Config.LocLinkLoc Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = LocLinkLoc ]
{

Property SourceLoc As DHCCL.Location [ Required, SqlColumnNumber = 2 ];

Property TargetLoc As DHCCL.Location [ Required, SqlColumnNumber = 3 ];

Property ExternalID As %String [ SqlColumnNumber = 4 ];

Index Source On SourceLoc;

Index Ext On ExternalID;

Storage Default
{
<Data name="LocLinkLocDefaultData">
<Value name="1">
<Value>SourceLoc</Value>
</Value>
<Value name="2">
<Value>TargetLoc</Value>
</Value>
<Value name="3">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.LocLinkLocD</DataLocation>
<DefaultData>LocLinkLocDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.LocLinkLocD</IdLocation>
<IndexLocation>^DHCCL.Config.LocLinkLocI</IndexLocation>
<StreamLocation>^DHCCL.Config.LocLinkLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
