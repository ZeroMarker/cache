///     
Class dbo.SYSGridConfigure Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_GridConfigure, StorageStrategy = Default ]
{

/// Foreign Key FKGridConfigureMenu created via DDL
ForeignKey FKGridConfigureMenu(MenuDR) References dbo.SYSMenu(PKSYSMENU) [ SqlName = FK_GridConfigureMenu ];

/// Foreign Key FKGridConfigureWorkGroupMachine created via DDL
ForeignKey FKGridConfigureWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_GridConfigureWorkGroupMachine ];

Index IndexMaster On (MenuDR, GridID, WorkGroupMachineDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSYSGRIDCONFIGURE On RowID [ PrimaryKey, SqlName = PK_SYS_GRIDCONFIGURE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MenuDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property GridID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Title As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property Field As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

Property Width As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ SqlColumnNumber = 8 ];

Property Align As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 9 ];

Property Sortable As %Library.Boolean [ SqlColumnNumber = 10 ];

Property Resizeable As %Library.Boolean [ SqlColumnNumber = 11 ];

Property Hidden As %Library.Boolean [ SqlColumnNumber = 12 ];

Property Checkbox As %Library.Boolean [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="SYSGridConfigureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuDR</Value>
</Value>
<Value name="3">
<Value>GridID</Value>
</Value>
<Value name="4">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="5">
<Value>Title</Value>
</Value>
<Value name="6">
<Value>Field</Value>
</Value>
<Value name="7">
<Value>Width</Value>
</Value>
<Value name="8">
<Value>Align</Value>
</Value>
<Value name="9">
<Value>Sortable</Value>
</Value>
<Value name="10">
<Value>Resizeable</Value>
</Value>
<Value name="11">
<Value>Hidden</Value>
</Value>
<Value name="12">
<Value>Checkbox</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSGridConfigureD</DataLocation>
<DefaultData>SYSGridConfigureDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSGridConfigureD</IdLocation>
<IndexLocation>^dbo.SYSGridConfigureI</IndexLocation>
<StreamLocation>^dbo.SYSGridConfigureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
