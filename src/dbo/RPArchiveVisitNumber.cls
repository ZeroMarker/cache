Class dbo.RPArchiveVisitNumber Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_ArchiveVisitNumber ]
{

/// Foreign Key FKArcWorkGroupMachine created via DDL
ForeignKey FKArcWorkGroupMachine(ArcWorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_ArcWorkGroupMachine ];

/// Foreign Key FKVisitNumber created via DDL
ForeignKey FKVisitNumber(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_VisitNumber ];

Index IndexMaster On (ArcWorkGroupMachineDR, ArcDate, VisitNumberDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSended On (Sended, ArcDate) [ SqlName = Index_Sended, Type = index ];

/// DDL Primary Key Specification
Index PKBTARCHIVEWGMTESTCODE On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEQC, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ArcWorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ArcDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ArcTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Sended As %Library.Boolean [ SqlColumnNumber = 7 ];

Property SendDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property SendTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RPArchiveVisitNumberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArcWorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>ArcDate</Value>
</Value>
<Value name="4">
<Value>VisitNumberDR</Value>
</Value>
<Value name="5">
<Value>ArcTime</Value>
</Value>
<Value name="6">
<Value>Sended</Value>
</Value>
<Value name="7">
<Value>SendDate</Value>
</Value>
<Value name="8">
<Value>SendTime</Value>
</Value>
</Data>
<DataLocation>^dbo.RPArchiveVisitNumberD</DataLocation>
<DefaultData>RPArchiveVisitNumberDefaultData</DefaultData>
<IdLocation>^dbo.RPArchiveVisitNumberD</IdLocation>
<IndexLocation>^dbo.RPArchiveVisitNumberI</IndexLocation>
<StreamLocation>^dbo.RPArchiveVisitNumberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
