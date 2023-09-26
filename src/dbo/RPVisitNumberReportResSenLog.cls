/// 药敏结果日志
Class dbo.RPVisitNumberReportResSenLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportResSenLog ]
{

/// Foreign Key FKRPVisitNumberReportResSenLogVisitNumberReportResLogDR created via DDL
ForeignKey FKRPVisitNumberReportResSenLogVisitNumberReportResLogDR(VisitNumberReportResLogDR) References dbo.RPVisitNumberReportResLog(PKRPVisitNumberReportResLog) [ SqlName = FK_RPVisitNumberReportResSenLogVisitNumberReportResLogDR ];

/// Foreign Key FKRPVisitNumberReportResSenLogAntibioticsDR created via DDL
ForeignKey FKRPVisitNumberReportResSenLogAntibioticsDR(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_RPVisitNumberReportResSenLogAntibioticsDR ];

/// Foreign Key FKRPVisitNumberReportResSenLogSensitivityDR created via DDL
ForeignKey FKRPVisitNumberReportResSenLogSensitivityDR(SensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_RPVisitNumberReportResSenLogSensitivityDR ];

/// Foreign Key FKRPVisitNumberReportResSenLogAntibioticsClassDR created via DDL
ForeignKey FKRPVisitNumberReportResSenLogAntibioticsClassDR(AntibioticsClassDR) References dbo.BTAntibioticsClass(PKBTAntibioticsClass) [ SqlName = FK_RPVisitNumberReportResSenLogAntibioticsClassDR ];

/// Foreign Key FKRPVisitNumberReportResSenLogMachSensitivityDR created via DDL
ForeignKey FKRPVisitNumberReportResSenLogMachSensitivityDR(MachSensitivityDR) References dbo.BTSensitivity(PKBTSENSITIVITY) [ SqlName = FK_RPVisitNumberReportResSenLogMachSensitivityDR ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPORTRESSENLOG On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPORTRESSEN, Type = index, Unique ];

Index IndexVisitNumberReportResLogDR On (VisitNumberReportResLogDR, AntibioticsDR) [ SqlName = Index_VisitNumberReportResLogDR, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告结果  
Property VisitNumberReportResLogDR As %Library.Float [ Required, SqlColumnNumber = 3 ];

/// 抗生素  
Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 实验方法  
Property SenMethod As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

/// 结果值  
Property SenValue As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 药敏结果  
Property SensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// I折点范围  
Property IRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// S折点范围  
Property SRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// R折点范围  
Property RRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// AntibioticsClassDR  
Property AntibioticsClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// CheckType  
Property CheckType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 13 ];

/// PromptType  
Property PromptType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 14 ];

/// Prompt  
Property Prompt As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 15 ];

/// SDDRanges  
Property SDDRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

/// MachSensitivityDR  
Property MachSensitivityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 是否报告  {1:true,0:false}
Property Reported As %Library.Boolean [ SqlColumnNumber = 18 ];

/// 专家规则ID  
Property ExpertRuleID As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="RPVisitNumberReportResSenLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportResLogDR</Value>
</Value>
<Value name="3">
<Value>AntibioticsDR</Value>
</Value>
<Value name="4">
<Value>SenMethod</Value>
</Value>
<Value name="5">
<Value>SenValue</Value>
</Value>
<Value name="6">
<Value>SensitivityDR</Value>
</Value>
<Value name="7">
<Value>IRanges</Value>
</Value>
<Value name="8">
<Value>SRanges</Value>
</Value>
<Value name="9">
<Value>RRanges</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>AntibioticsClassDR</Value>
</Value>
<Value name="12">
<Value>CheckType</Value>
</Value>
<Value name="13">
<Value>PromptType</Value>
</Value>
<Value name="14">
<Value>Prompt</Value>
</Value>
<Value name="15">
<Value>SDDRanges</Value>
</Value>
<Value name="16">
<Value>MachSensitivityDR</Value>
</Value>
<Value name="17">
<Value>Reported</Value>
</Value>
<Value name="18">
<Value>ExpertRuleID</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberRepResSenLogD</DataLocation>
<DefaultData>RPVisitNumberReportResSenLogDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberRepResSenLogD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberRepResSenLogI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberRepResSenLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
