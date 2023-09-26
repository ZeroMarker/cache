/// 检查报告关联表
Class User.EnsRISExamReport Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlTableName = Ens_RISExamReport ]
{

ForeignKey FKEXAMIDREFERENCERISREPORT(RISSRReportID) References User.EnsRISReportResult(RISREPORTPKey) [ SqlName = FK_EXAMID_REFERENCE_RISREPORT ];

/// DDL Primary Key Specification
Index RISEXAMREPORTPKey On (RISSRReportID, RISSRExamID, RISSROrderItemID);

Index RELORDEREXAMID On RISSRExamID;

/// 报告ID 
Property RISSRReportID As %Library.String [ SqlColumnNumber = 2, SqlFieldName = RISSR_ReportID ];

/// 检查号 
Property RISSRExamID As %Library.String [ SqlColumnNumber = 3, SqlFieldName = RISSR_ExamID ];

/// 医嘱号
Property RISSROrderItemID As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = RISSR_OrderItemID ];

/// 患者ID
Property RISSRPatientID As User.PAPatMas [ SqlColumnNumber = 5, SqlFieldName = RISSR_PatientID ];

/// 就诊号
Property RISSRVisitNumber As User.PAAdm [ SqlColumnNumber = 6, SqlFieldName = RISSR_VisitNumber ];

/// 时间戳 
Property RISSRUpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, Required, SqlColumnNumber = 7, SqlFieldName = RISSR_UpdateDate ];

/// 时间戳
Property RISSRUpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, Required, SqlColumnNumber = 8, SqlFieldName = RISSR_UpdateTime ];

Storage Default
{
<Data name="EnsRISExamReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RISSRReportID</Value>
</Value>
<Value name="3">
<Value>RISSRExamID</Value>
</Value>
<Value name="4">
<Value>RISSROrderItemID</Value>
</Value>
<Value name="5">
<Value>RISSRPatientID</Value>
</Value>
<Value name="6">
<Value>RISSRVisitNumber</Value>
</Value>
<Value name="7">
<Value>RISSRUpdateDate</Value>
</Value>
<Value name="8">
<Value>RISSRUpdateTime</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsRISExamReportD</DataLocation>
<DefaultData>EnsRISExamReportDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsRISExamReportD</IdLocation>
<IndexLocation>^Busi.ENS.EnsRISExamReportI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsRISExamReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
