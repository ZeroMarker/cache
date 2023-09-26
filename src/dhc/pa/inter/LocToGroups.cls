/// LocToGroups
Class dhc.pa.inter.LocToGroups Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LocToGroups_rowid, SqlTableName = LocToGroups ]
{

/// Loc
Property LocDr As dhc.pa.inter.Locs [ SqlColumnNumber = 2, SqlFieldName = LocToGroups_LocDr ];

/// Groups
Property GroupDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 3, SqlFieldName = LocToGroups_GroupDr ];

Index LocGroup On (LocDr As Exact, GroupDr As Exact);

Index GroupLoc On (GroupDr As Exact, LocDr As Exact);

Storage Default
{
<Data name="LocToGroupsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocToGroupscode</Value>
</Value>
<Value name="3">
<Value>LocToGroupsname</Value>
</Value>
<Value name="4">
<Value>GroupDr</Value>
</Value>
<Value name="5">
<Value>LocDr</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.inter.LocToGroupsD</DataLocation>
<DefaultData>LocToGroupsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.inter.LocToGroupsD</IdLocation>
<IndexLocation>^dhc.pa.inter.LocToGroupsI</IndexLocation>
<StreamLocation>^dhc.pa.inter.LocToGroupsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
