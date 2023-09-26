Class dbo.RPVisitNumberRepResMedGuid Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberRepResMedGuid ]
{

Index IndexReportItem On (VisitNumberReportDR, TestCodeDR, LevelNo) [ SqlName = Index_ReportItem, Type = index ];

/// Foreign Key FKVisitNumberRepResMedGuid created via DDL
ForeignKey FKVisitNumberRepResMedGuid(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberRepResMedGuid ];

/// Foreign Key FKVisitNumberRepResMedGuidTC created via DDL
ForeignKey FKVisitNumberRepResMedGuidTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_VisitNumberRepResMedGuidTC ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property LevelNo As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

Property AntibioticsName As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 7 ];

Property MidGuidSourceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RPVisitNumberRepResMedGuidDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>LevelNo</Value>
</Value>
<Value name="5">
<Value>AntibioticsName</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>MidGuidSourceDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberRepResMedGuidD</DataLocation>
<DefaultData>RPVisitNumberRepResMedGuidDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberRepResMedGuidD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberRepResMedGuidI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberRepResMedGuidS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
