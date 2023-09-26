/// BTTestCodeRepPanicLoc
Class dbo.BTTestCodeRepPanicLoc Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeRepPanicLoc ]
{

Index IndexMaster On (TCReportingPanicDR, LocationDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTestCodeRepPanicLoc On RowID [ PrimaryKey, SqlName = PK_BT_TestCodeRepPanicLoc, Type = index, Unique ];

/// Foreign Key FKTestCodeRanges created via DDL
ForeignKey FKTestCodeReportingPanicRowID(TCReportingPanicDR) References dbo.BTTestCodeReportingPanic(PKBTTESTCODEREPORTINGPANIC) [ SqlName = FK_TestCodeReportingPanicRowID ];

/// Foreign Key FKTestCodeRanges created via DDL
ForeignKey FKTestCodeReportingPanicLoc(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_TestCodeReportingPanicLoc ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 危机值项目主键  
Property TCReportingPanicDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 申请科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

///       
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTTestCodeRepPanicLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TCReportingPanicDR</Value>
</Value>
<Value name="3">
<Value>LocationDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeRepPanicLocD</DataLocation>
<DefaultData>BTTestCodeRepPanicLocDefaultData</DefaultData>
<IdLocation>^dbo.BTTestCodeRepPanicLocD</IdLocation>
<IndexLocation>^dbo.BTTestCodeRepPanicLocI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeRepPanicLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
