///     
Class dbo.RPVisitNumberReportCollect Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportCollect, StorageStrategy = Default ]
{

Index IndexCollectDate On (CollectDate, VisitNumberReportDR) [ SqlName = Index_CollectDate, Type = index ];

Index IndexVisitNumberReportDR On (VisitNumberReportDR, CollectDate) [ SqlName = Index_VisitNumberReportDR, Type = index ];

Index IndexRegNo On RegNo [ SqlName = Index_RegNo, Type = index ];

Index IndexCollectTypeDR On (CollectTypeDR, VisitNumberReportDR) [ SqlName = Index_CollectTypeDR, Type = index ];

Index IndexCollectUserDR On (CollectUserDR, CollectDate) [ SqlName = Index_CollectUserDR, Type = index ];

/// Foreign Key FKRPVisitNumberCollectVisitNumberReportDR created via DDL
ForeignKey FKRPVisitNumberCollectVisitNumberReportDR(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_RPVisitNumberCollectVisitNumberReportDR ];

/// Foreign Key FKRPVisitNumberCollectCollectUserDR created via DDL
ForeignKey FKRPVisitNumberCollectCollectUserDR(CollectUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPVisitNumberCollectCollectUserDR ];

/// Foreign Key FKRPVisitNumberCollectCollectUserDR created via DDL
ForeignKey FKRPVisitNumberCollectCollectTypeDR(CollectTypeDR) References dbo.BTReportCollectType(PKBTREPORTCOLLECTTYPE) [ SqlName = FK_RPVisitNumberCollectCollectTypeDR ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERCOLLECT On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERCOLLECT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property CollectDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property CollectTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property CollectUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property CollectTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

Property IsShare As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="RPVisitNumberReportCollectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>CollectDate</Value>
</Value>
<Value name="4">
<Value>CollectTime</Value>
</Value>
<Value name="5">
<Value>CollectUserDR</Value>
</Value>
<Value name="6">
<Value>CollectTypeDR</Value>
</Value>
<Value name="7">
<Value>RegNo</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>IsShare</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportCollectD</DataLocation>
<DefaultData>RPVisitNumberReportCollectDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberReportCollectD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportCollectI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportCollectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
