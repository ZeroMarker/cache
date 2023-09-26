///     
Class dbo.BTRGPosition Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_Position, StorageStrategy = Default ]
{

Index IndexCode On (ReagentGroupDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (ReagentGroupDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTRGPOSITION On RowID [ PrimaryKey, SqlName = PK_BTRG_POSITION, Type = index, Unique ];

/// Foreign Key FKRGPositionGroup created via DDL
ForeignKey FKRGPositionGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_Position_Group ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTRGPositionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>HospitalDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGPositionD</DataLocation>
<DefaultData>BTRGPositionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGPositionD</IdLocation>
<IndexLocation>^dbo.BTRGPositionI</IndexLocation>
<StreamLocation>^dbo.BTRGPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
