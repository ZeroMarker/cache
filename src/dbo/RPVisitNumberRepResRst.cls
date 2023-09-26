/// 耐药机制结果
Class dbo.RPVisitNumberRepResRst Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberRepResRst, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberReportResultRst created via DDL
ForeignKey FKVisitNumberReportResultRst(VisitNumberReportResultDR) References dbo.RPVisitNumberReportResult(PKRPVISITNUMBERREPORTRESULT) [ SqlName = FK_VisitNumberReportResultRst ];

/// Foreign Key FKVisitNumberReportResultRstTc created via DDL
ForeignKey FKVisitNumberReportResultRstTc(ResistanceItemDR) References dbo.BTMCResistanceItem(PKBTMCRESISTANCEITEM) [ SqlName = FK_VisitNumberReportResultRstTc ];

Index IndexDataMaster On (VisitNumberReportResultDR, ResistanceItemDR) [ SqlName = Index_DataMaster, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPRESRST On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPRESRST, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告结果  
Property VisitNumberReportResultDR As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Required, SqlColumnNumber = 3 ];

/// 耐药项目  
Property ResistanceItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 结果值  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RPVisitNumberRepResRstDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportResultDR</Value>
</Value>
<Value name="3">
<Value>ResistanceItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberRepResRstD</DataLocation>
<DefaultData>RPVisitNumberRepResRstDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberRepResRstD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberRepResRstI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberRepResRstS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
