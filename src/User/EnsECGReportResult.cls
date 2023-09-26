/// 心电报告结果表
Class User.EnsECGReportResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {_SYSTEM}, SqlRowIdPrivate, SqlTableName = Ens_ECGReportResult ]
{

/// DDL Primary Key Specification
Index RISItemResultPKey On ECGRRRowID [ PrimaryKey, Type = index, Unique ];

Index IndexReportItem On (ECGRRReportID, ECGRRItemCode) [ SqlName = Index_ReportItem, Type = index, Unique ];

ForeignKey FKRISITEMRESULTREFERENCEREPORTID(ECGRRReportID) References User.EnsRISReportResult(RISREPORTPKey) [ SqlName = FK_RISITEMRESULT_REFERENCE_REPORTID ];

/// 序列ID
Property ECGRRRowID As %Library.Integer [ InitialExpression = {$I(^Busi.ENS.EnsECGReportResultC)}, Required, SqlColumnNumber = 2, SqlFieldName = ECGRR_RowID ];

/// 报告ID
Property ECGRRReportID As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 3, SqlFieldName = ECGRR_ReportID ];

/// 患者ID
Property ECGRRPatientID As User.PAPatMas [ Required, SqlColumnNumber = 4, SqlFieldName = ECGRR_PatientID ];

/// 就诊号
Property ECGRRVisitNumber As User.PAAdm [ Required, SqlColumnNumber = 5, SqlFieldName = ECGRR_VisitNumber ];

/// 检查项目代码
Property ECGRRItemCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 6, SqlFieldName = ECGRR_ItemCode ];

/// 检查项目名称
Property ECGRRItemDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 7, SqlFieldName = ECGRR_ItemDesc ];

/// 心率 
Property ECGRRHeartRate As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 8, SqlFieldName = ECGRR_HeartRate ];

/// p-r间期(ms)
Property ECGRRPR As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 9, SqlFieldName = ECGRR_PR ];

/// qrs波时间(ms)
Property ECGRRQRS As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 10, SqlFieldName = ECGRR_QRS ];

/// qt间期(ms)
Property ECGRRQT As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 11, SqlFieldName = ECGRR_QT ];

/// qtc(ms)
Property ECGRRQTC As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 12, SqlFieldName = ECGRR_QTC ];

/// RV5
Property ECGRRRV5 As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 13, SqlFieldName = ECGRR_RV5 ];

/// SV1
Property ECGRRSV1 As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 14, SqlFieldName = ECGRR_SV1 ];

/// 诊断描述
Property ECGRRDiagnose As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 15, SqlFieldName = ECGRR_Diagnnose ];

/// 时间戳日期
Property ECGRRUpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, Required, SqlColumnNumber = 16, SqlFieldName = ECGRR_UpdateDate ];

/// 时间戳时间
Property ECGRRUpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, Required, SqlColumnNumber = 17, SqlFieldName = ECGRR_UpdateTime ];

Storage Default
{
<Data name="EnsECGReportResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ECGRRRowID</Value>
</Value>
<Value name="3">
<Value>ECGRRReportID</Value>
</Value>
<Value name="4">
<Value>ECGRRPatientID</Value>
</Value>
<Value name="5">
<Value>ECGRRVisitNumber</Value>
</Value>
<Value name="6">
<Value>ECGRRItemCode</Value>
</Value>
<Value name="7">
<Value>ECGRRItemDesc</Value>
</Value>
<Value name="8">
<Value>ECGRRHeartRate</Value>
</Value>
<Value name="9">
<Value>ECGRRPR</Value>
</Value>
<Value name="10">
<Value>ECGRRQRS</Value>
</Value>
<Value name="11">
<Value>ECGRRQT</Value>
</Value>
<Value name="12">
<Value>ECGRRQTC</Value>
</Value>
<Value name="13">
<Value>ECGRRRV5</Value>
</Value>
<Value name="14">
<Value>ECGRRSV1</Value>
</Value>
<Value name="15">
<Value>ECGRRDiagnose</Value>
</Value>
<Value name="16">
<Value>LISIRUpdateDate</Value>
</Value>
<Value name="17">
<Value>LISIRUpdateTime</Value>
</Value>
<Value name="18">
<Value>ECGRRUpdateDate</Value>
</Value>
<Value name="19">
<Value>ECGRRUpdateTime</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsECGReportResultD</DataLocation>
<DefaultData>EnsECGReportResultDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsECGReportResultD</IdLocation>
<IndexLocation>^Busi.ENS.EnsECGReportResultI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsECGReportResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
