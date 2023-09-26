///     
Class dbo.OTComputerLocation Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_ComputerLocation ]
{

/// Foreign Key FKOTComputerLocationComputerDR created via DDL
ForeignKey FKOTComputerLocationComputerDR(ComputerDR) References dbo.OTComputer(PKOTCOMPUTER) [ SqlName = FK_OTComputerLocationComputerDR ];

/// Foreign Key FKOTComputerLocationLocationDR created via DDL
ForeignKey FKOTComputerLocationLocationDR(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_OTComputerLocationLocationDR ];

/// DDL Primary Key Specification
Index PKOTCOMPUTERLOCATION On RowID [ PrimaryKey, SqlName = PK_OT_COMPUTERLOCATION, Type = index, Unique ];

Index IndexMaster On (ComputerDR, LocationDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ComputerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="OTComputerLocationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ComputerDR</Value>
</Value>
<Value name="3">
<Value>LocationDR</Value>
</Value>
</Data>
<DataLocation>^dbo.OTComputerLocationD</DataLocation>
<DefaultData>OTComputerLocationDefaultData</DefaultData>
<IdLocation>^dbo.OTComputerLocationD</IdLocation>
<IndexLocation>^dbo.OTComputerLocationI</IndexLocation>
<StreamLocation>^dbo.OTComputerLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
