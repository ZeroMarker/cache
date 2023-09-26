/// 阳性归档科室
Class dbo.BTArchiveWGMLoc Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_ArchiveWGMLoc ]
{

/// Foreign Key FKArchiveWG created via DDL
ForeignKey FKArchiveWGM(ArchiveWGMDR) References dbo.BTArchiveWGM(PKBTARCHIVEWG) [ SqlName = FK_ArchiveWGM ];

/// Foreign Key FKLocation created via DDL
ForeignKey FKLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_Location ];

/// Foreign Key FKTestCode created via DDL
ForeignKey FKTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCode ];

Index IndexMaster On (ArchiveWGMDR, LocationDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTMIMACHINEQC On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEQC, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// ArchiveWGMDR  
Property ArchiveWGMDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// CheckOP  
Property CheckOP As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTArchiveWGMLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArchiveWGDR</Value>
</Value>
<Value name="3">
<Value>LocationDR</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>CheckOP</Value>
</Value>
<Value name="6">
<Value>ArchiveWGMDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTArchiveWGMLocD</DataLocation>
<DefaultData>BTArchiveWGMLocDefaultData</DefaultData>
<IdLocation>^dbo.BTArchiveWGMLocD</IdLocation>
<IndexLocation>^dbo.BTArchiveWGMLocI</IndexLocation>
<StreamLocation>^dbo.BTArchiveWGMLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
