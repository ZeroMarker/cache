///     
Class dbo.MCCulture Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = MC_Culture, StorageStrategy = Default ]
{

Index IndexDataMaster On (OrderNo, ProcessRecordDR) [ SqlName = Index_DataMaster, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKMCCULTURE On RowID [ PrimaryKey, SqlName = PK_MC_CULTURE, Type = index, Unique ];

/// Foreign Key FKMCCultureMedium created via DDL
ForeignKey FKMCCultureMedium(MediumDR) References dbo.BTMCMedium(PKBTMCMEDIUM) [ SqlName = FK_MC_Culture_Medium ];

/// Foreign Key FKMCCulturePR created via DDL
ForeignKey FKMCCulturePR(ProcessRecordDR) References dbo.MCProcessRecord(PKMCPROCESSRECORD) [ SqlName = FK_MC_Culture_PR ];

/// Foreign Key FKMCCultureResultBT created via DDL
ForeignKey FKMCCultureResultBT(ResultBTDR) References dbo.BTBaseTable(PKBTBASETABLE) [ SqlName = FK_MC_Culture_ResultBT ];

/// Foreign Key FKMCCultureStateBT created via DDL
ForeignKey FKMCCultureStateBT(StateBTDR) References dbo.BTBaseTable(PKBTBASETABLE) [ SqlName = FK_MC_Culture_StateBT ];

/// Foreign Key FKMCCultureVisitNumberReport created via DDL
ForeignKey FKMCCultureVisitNumberReport(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_MC_Culture_VisitNumberReport ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ProcessRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property MediumDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Condition As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property StateBTDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property StateDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Property ResultBTDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

Storage Default
{
<Data name="MCCultureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProcessRecordDR</Value>
</Value>
<Value name="3">
<Value>OrderNo</Value>
</Value>
<Value name="4">
<Value>MediumDR</Value>
</Value>
<Value name="5">
<Value>Condition</Value>
</Value>
<Value name="6">
<Value>StateBTDR</Value>
</Value>
<Value name="7">
<Value>StateDesc</Value>
</Value>
<Value name="8">
<Value>ResultBTDR</Value>
</Value>
<Value name="9">
<Value>Description</Value>
</Value>
<Value name="10">
<Value>VisitNumberReportDR</Value>
</Value>
</Data>
<DataLocation>^dbo.MCCultureD</DataLocation>
<DefaultData>MCCultureDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.MCCultureD</IdLocation>
<IndexLocation>^dbo.MCCultureI</IndexLocation>
<StreamLocation>^dbo.MCCultureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
