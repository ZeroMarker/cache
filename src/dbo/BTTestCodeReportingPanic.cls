/// BTTestCodeReportingPanic
Class dbo.BTTestCodeReportingPanic Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeReportingPanic ]
{

Index IndexMaster On (TestCodeDR, Sequence) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTESTCODEREPORTINGPANIC On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODEREPORTINGPANIC, Type = index, Unique ];

/// Foreign Key FKTestCodeRanges created via DDL
ForeignKey FKTestCodeReportingPanic(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodeReportingPanic ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 结果天数  
Property ResultDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 等级类型  
Property RangeType As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTTestCodeReportingPanicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>ResultDays</Value>
</Value>
<Value name="4">
<Value>RangeType</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeReportingPanicD</DataLocation>
<DefaultData>BTTestCodeReportingPanicDefaultData</DefaultData>
<IdLocation>^dbo.BTTestCodeReportingPanicD</IdLocation>
<IndexLocation>^dbo.BTTestCodeReportingPanicI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeReportingPanicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
