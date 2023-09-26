Class dbo.OTComputerWard Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_ComputerWard ]
{

/// Foreign Key FKOTComputerWardComputerDR created via DDL
ForeignKey FKOTComputerWardComputerDR(ComputerDR) References dbo.OTComputer(PKOTCOMPUTER) [ SqlName = FK_OTComputerWardComputerDR ];

/// Foreign Key FKOTComputerLocationLocationDR created via DDL
ForeignKey FKOTComputerWardWardDR(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_OTComputerWardWardDR ];

/// DDL Primary Key Specification
Index PKOTCOMPUTERWARD On RowID [ PrimaryKey, SqlName = PK_OT_COMPUTERWARD, Type = index, Unique ];

Index IndexMaster On (ComputerDR, WardDR) [ SqlName = Index_Master, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 电脑  
Property ComputerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 病区 
Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="OTComputerWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ComputerDR</Value>
</Value>
<Value name="3">
<Value>WardDR</Value>
</Value>
</Data>
<DataLocation>^dbo.OTComputerWardD</DataLocation>
<DefaultData>OTComputerWardDefaultData</DefaultData>
<IdLocation>^dbo.OTComputerWardD</IdLocation>
<IndexLocation>^dbo.OTComputerWardI</IndexLocation>
<StreamLocation>^dbo.OTComputerWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
