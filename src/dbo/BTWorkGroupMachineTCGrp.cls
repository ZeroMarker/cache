///     
Class dbo.BTWorkGroupMachineTCGrp Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WorkGroupMachineTCGrp, StorageStrategy = Default ]
{

Index IndexMaster On (WorkGroupMachineDR, Code) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTWORKGROUPMACHINETCGRP On RowID [ PrimaryKey, SqlName = PK_BT_WORKGROUPMACHINETCGRP, Type = index, Unique ];

/// Foreign Key FKWorkGroupMachine created via DDL
ForeignKey FKWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_WorkGroupMachine ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

Property ColNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTWorkGroupMachineTCGrpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>ColNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWorkGroupMachineTCGrpD</DataLocation>
<DefaultData>BTWorkGroupMachineTCGrpDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTWorkGroupMachineTCGrpD</IdLocation>
<IndexLocation>^dbo.BTWorkGroupMachineTCGrpI</IndexLocation>
<StreamLocation>^dbo.BTWorkGroupMachineTCGrpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
