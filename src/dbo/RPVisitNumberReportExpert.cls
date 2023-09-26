/// 报告专家规则
Class dbo.RPVisitNumberReportExpert Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportExpert ]
{

/// Foreign Key FKRPVisitNumberReportExpertVisitNumberReportDR created via DDL
ForeignKey FKRPVisitNumberReportExpertVisitNumberReportDR(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_RPVisitNumberReportExpertVisitNumberReportDR ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPORTEXPERT On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPORTEXPERT, Type = index, Unique ];

Index IndexVisitNumberReportDR On (VisitNumberReportDR, ExpertRuleID) [ SqlName = Index_VisitNumberReportDR, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 专家规则ID  
Property ExpertRuleID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 专家规则  
Property ExpertRule As %Library.String(COLLATION = "Exact", MAXLEN = 3000) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="RPVisitNumberReportExpertDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>ExpertRuleID</Value>
</Value>
<Value name="4">
<Value>ExpertRule</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportExpertD</DataLocation>
<DefaultData>RPVisitNumberReportExpertDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberReportExpertD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportExpertI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportExpertS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
