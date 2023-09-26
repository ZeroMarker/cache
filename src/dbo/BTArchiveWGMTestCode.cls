/// 阳性归档项目
Class dbo.BTArchiveWGMTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_ArchiveWGMTestCode ]
{

/// Foreign Key FKArchiveWG created via DDL
ForeignKey FKArchiveWGM(ArchiveWGMDR) References dbo.BTArchiveWGM(PKBTARCHIVEWG) [ SqlName = FK_ArchiveWGM ];

/// Foreign Key FKTestCode created via DDL
ForeignKey FKTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCode ];

Index IndexMaster On (ArchiveWGMDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTARCHIVEWGMTESTCODE On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEQC, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// ArchiveWGMDR  
Property ArchiveWGMDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// ResFlag  
Property ResFlag As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTArchiveWGMTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArchiveWGDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>ResFlag</Value>
</Value>
<Value name="5">
<Value>ArchiveWGMDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTArchiveWGMTestCodeD</DataLocation>
<DefaultData>BTArchiveWGMTestCodeDefaultData</DefaultData>
<IdLocation>^dbo.BTArchiveWGMTestCodeD</IdLocation>
<IndexLocation>^dbo.BTArchiveWGMTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTArchiveWGMTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
