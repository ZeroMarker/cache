/// 报告阅读记录
Class dbo.RPVisitNumberReportRead Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportRead, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberReportRead created via DDL
ForeignKey FKVisitNumberReportRead(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberReportRead ];

/// Foreign Key FKVisitNumverReportDoctor created via DDL
ForeignKey FKVisitNumverReportDoctor(ReadDoctorDR) References dbo.BTDoctor(PKBTDOCTOR) [ SqlName = FK_VisitNumverReportDoctor ];

Index IndexMaster On (VisitNumberReportDR, ReadDate, ReadTime) [ SqlName = Index_Master, Type = index ];

Index IndexReadDoctor On (VisitNumberReportDR, ReadDoctorDR) [ SqlName = Index_ReadDoctor, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPORTREAD On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPORTREAD, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 阅读日期  
Property ReadDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 阅读时间  
Property ReadTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 阅读者  
Property ReadDoctorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 解读说明  
Property ReadNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="RPVisitNumberReportReadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>ReadDate</Value>
</Value>
<Value name="4">
<Value>ReadTime</Value>
</Value>
<Value name="5">
<Value>ReadDoctorDR</Value>
</Value>
<Value name="6">
<Value>ReadNotes</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportReadD</DataLocation>
<DefaultData>RPVisitNumberReportReadDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberReportReadD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportReadI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportReadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
