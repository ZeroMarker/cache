/// 检查、病理报告结果表
Class User.EnsRISReportResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {_SYSTEM}, SqlRowIdPrivate, SqlTableName = Ens_RISReportResult ]
{

/// DDL Primary Key Specification
Index RISREPORTPKey On RISRReportID [ PrimaryKey, Type = index, Unique ];

Index RISRExamIDIndex On RISRExamID [ Type = index ];

Index RISRPatientIDCheckDateTimeIndex On (RISRPatientID, RISRCheckDate, RISRCheckTime) [ Type = index ];

Index RISRPatientIDReportDateTimeIndex On (RISRPatientID, RISRReportDate, RISRReportTime) [ Type = index ];

Index RISRUpdateTimeIndex On (RISRUpdateDate, RISRUpdateTime);

Index RISRCheckDateTimeIndex On (RISRCheckDate, RISRCheckTime);

Index RISRReportDateTimeIndex On (RISRReportDate, RISRReportTime);

Index RISRVisitNumberIndex On RISRVisitNumber [ Type = index ];

/// 报告号
Property RISRReportID As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 2, SqlFieldName = RISR_ReportID ];

/// 检查号
Property RISRExamID As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 3, SqlFieldName = RISR_ExamID ];

/// 医嘱ID
Property RISROrderItemID As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ Required, SqlColumnNumber = 4, SqlFieldName = RISR_OrderItemID ];

/// 患者ID
Property RISRPatientID As User.PAPatMas [ Required, SqlColumnNumber = 5, SqlFieldName = RISR_PatientID ];

/// 就诊号码
Property RISRVisitNumber As User.PAAdm [ Required, SqlColumnNumber = 6, SqlFieldName = RISR_VisitNumber ];

/// 系统类型代码
Property RISRSysCode As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ Required, SqlColumnNumber = 7, SqlFieldName = RISR_SysCode ];

/// 报告医生代码 
Property RISRReportDocCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 8, SqlFieldName = RISR_ReportDocCode ];

/// 报告医生描述
Property RISRReportDocDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 9, SqlFieldName = RISR_ReportDocDesc ];

/// 报告日期
Property RISRReportDate As %Library.Date [ Required, SqlColumnNumber = 10, SqlFieldName = RISR_ReportDate ];

/// 报告时间
Property RISRReportTime As %Library.Time [ Required, SqlColumnNumber = 11, SqlFieldName = RISR_ReportTime ];

/// 审核医生代码
Property RISRCheckDocCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 12, SqlFieldName = RISR_CheckDocCode ];

/// 审核医生描述
Property RISRCheckDocDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 13, SqlFieldName = RISR_CheckDocDesc ];

/// 审核日期
Property RISRCheckDate As %Library.Date [ SqlColumnNumber = 14, SqlFieldName = RISR_CheckDate ];

/// 审核时间
Property RISRCheckTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = RISR_CheckTime ];

/// 终审医生代码
Property RISRFinalCheckDocCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 16, SqlFieldName = RISR_FinalCheckDocCode ];

/// 终审医生描述
Property RISRFinalCheckDocDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 17, SqlFieldName = RISR_FinalCheckDocDesc ];

/// 终审日期
Property RISRFinalCheckDate As %Library.Date [ SqlColumnNumber = 18, SqlFieldName = RISR_FinalCheckDate ];

/// 终审时间
Property RISRFinalCheckTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = RISR_FinalCheckTime ];

/// 检查项目描述
Property RISRItemDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 128) [ SqlColumnNumber = 20, SqlFieldName = RISR_ItemDesc ];

/// 检查部位代码
Property RISRBACode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 21, SqlFieldName = RISR_BACode ];

/// 检查部位描述
Property RISRBADesc As %Library.String(COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 22, SqlFieldName = RISR_BADesc ];

/// 检查方法
Property RISRMethod As %Library.String(COLLATION = "EXACT", MAXLEN = 128) [ SqlColumnNumber = 23, SqlFieldName = RISR_Method ];

/// 检查所见
Property RISRExamDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 32000) [ SqlColumnNumber = 24, SqlFieldName = RISR_ExamDesc ];

/// 诊断意见
Property RISRDiagDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 32000) [ SqlColumnNumber = 25, SqlFieldName = RISR_DiagDesc ];

/// ACR代码
Property RISRACRCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 26, SqlFieldName = RISR_ACRCode ];

/// 报告建议
Property RISRAdviseDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 1024) [ SqlColumnNumber = 27, SqlFieldName = RISR_AdviseDesc ];

/// 是否已领取
Property RISRIsGet As %Library.String(COLLATION = "EXACT", MAXLEN = 1) [ SqlColumnNumber = 28, SqlFieldName = RISR_IsGet ];

/// 时间戳
Property RISRUpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, Required, SqlColumnNumber = 29, SqlFieldName = RISR_UpdateDate ];

/// 时间戳
Property RISRUpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, Required, SqlColumnNumber = 30, SqlFieldName = RISR_UpdateTime ];

/// 医嘱描述
Property RISROrderItemDesc As %String(COLLATION = "EXACT", MAXLEN = 500) [ Required, SqlColumnNumber = 31, SqlFieldName = RISR_OrderItemDesc ];

/// 图像链接
Property RISRImageSrc As %String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 32, SqlFieldName = RISR_ImageSrc ];

/// 图片报告链接
Property RISRReportImageSrc As %String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 33, SqlFieldName = RISR_ReportImageSrc ];

/// 是否危急
Property RISRWarnCode As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 34, SqlFieldName = RISR_WarnCode ];

/// 是否阳性
Property RISRIsPositive As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 35, SqlFieldName = RISR_IsPositive ];

/// 异常标记
Property RISRAbnormalFlags As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 36, SqlFieldName = RISR_AbnormalFlags ];

/// 麻醉医师工号(扩展以下字段，用于检查中的介入性麻醉)
Property RISRAnesDocCode As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 37, SqlFieldName = RISR_AnesDocCode ];

/// 麻醉医师姓名
Property RISRAnesDocName As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 38, SqlFieldName = RISR_AnesDocName ];

/// 麻醉方式代码
Property RISRAnesMethodCode As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 39, SqlFieldName = RISR_AnesMethodCode ];

/// 麻醉方式描述
Property RISRAnesMethodDesc As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 40, SqlFieldName = RISR_AnesMethodDesc ];

/// 麻醉分级代码
Property RISRAnesLevelCode As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 41, SqlFieldName = RISR_AnesLevelCode ];

/// 麻醉分级描述
Property RISRAnesLevelDesc As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 42, SqlFieldName = RISR_AnesLevelDesc ];

/// 麻醉开始时间
Property RISRAnesStartDateTime As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 43, SqlFieldName = RISR_AnesStartDateTime ];

/// 麻醉结束时间
Property RISRAnesEndDateTime As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 44, SqlFieldName = RISR_AnesEndDateTime ];

/// 冰冻号(病理)
Property RISRSliceFrozenNo As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 45, SqlFieldName = RISR_SliceFrozenNo ];

/// 送检材料(病理)
Property RISRInspMaterials As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 46, SqlFieldName = RISR_InspMaterials ];

/// 免疫组化(病理)
Property RISRImmuneGrpNo As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 47, SqlFieldName = RISR_ImmuneGrpNo ];

/// 报告状态（1审核，2取消审核，3作废）
Property RISRStatus As %String(COLLATION = "EXACT", MAXLEN = 10) [ InitialExpression = "1", SqlColumnNumber = 48, SqlFieldName = RISR_Status ];

/// 检查医生代码
Property RISRExamDocCode As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 49, SqlFieldName = RISR_ExamDocCode ];

/// 检查医生姓名
Property RISRExamDocDesc As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 50, SqlFieldName = RISR_ExamDocDesc ];

/// 检查日期
Property RISRExamDate As %Library.Date [ SqlColumnNumber = 51, SqlFieldName = RISR_ExamDate ];

/// 检查时间
Property RISRExamTime As %Library.Time [ SqlColumnNumber = 52, SqlFieldName = RISR_ExamTime ];

Storage Default
{
<Data name="EnsRISReportResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RISRReportID</Value>
</Value>
<Value name="3">
<Value>RISRExamID</Value>
</Value>
<Value name="4">
<Value>RISROrderItemID</Value>
</Value>
<Value name="5">
<Value>RISRPatientID</Value>
</Value>
<Value name="6">
<Value>RISRVisitNumber</Value>
</Value>
<Value name="7">
<Value>RISRSysCode</Value>
</Value>
<Value name="8">
<Value>RISRReportDocCode</Value>
</Value>
<Value name="9">
<Value>RISRReportDocDesc</Value>
</Value>
<Value name="10">
<Value>RISRReportDate</Value>
</Value>
<Value name="11">
<Value>RISRReportTime</Value>
</Value>
<Value name="12">
<Value>RISRCheckDocCode</Value>
</Value>
<Value name="13">
<Value>RISRCheckDocDesc</Value>
</Value>
<Value name="14">
<Value>RISRCheckDate</Value>
</Value>
<Value name="15">
<Value>RISRCheckTime</Value>
</Value>
<Value name="16">
<Value>RISRFinalCheckDocCode</Value>
</Value>
<Value name="17">
<Value>RISRFinalCheckDocDesc</Value>
</Value>
<Value name="18">
<Value>RISRFinalCheckDate</Value>
</Value>
<Value name="19">
<Value>RISRFinalCheckTime</Value>
</Value>
<Value name="20">
<Value>RISRItemDesc</Value>
</Value>
<Value name="21">
<Value>RISRBACode</Value>
</Value>
<Value name="22">
<Value>RISRBADesc</Value>
</Value>
<Value name="23">
<Value>RISRMethod</Value>
</Value>
<Value name="24">
<Value>RISRExamDesc</Value>
</Value>
<Value name="25">
<Value>RISRDiagDesc</Value>
</Value>
<Value name="26">
<Value>RISRACRCode</Value>
</Value>
<Value name="27">
<Value>RISRAdviseDesc</Value>
</Value>
<Value name="28">
<Value>RISRIsGet</Value>
</Value>
<Value name="29">
<Value>RISRUpdateDate</Value>
</Value>
<Value name="30">
<Value>RISRUpdateTime</Value>
</Value>
<Value name="31">
<Value>RISROrderItemDesc</Value>
</Value>
<Value name="32">
<Value>RISRImageSrc</Value>
</Value>
<Value name="33">
<Value>RISRReportImageSrc</Value>
</Value>
<Value name="34">
<Value>RISRWarnCode</Value>
</Value>
<Value name="35">
<Value>RISRIsPositive</Value>
</Value>
<Value name="36">
<Value>RISRAbnormalFlags</Value>
</Value>
<Value name="37">
<Value>RISRAnesDocCode</Value>
</Value>
<Value name="38">
<Value>RISRAnesDocName</Value>
</Value>
<Value name="39">
<Value>RISRAnesMethodCode</Value>
</Value>
<Value name="40">
<Value>RISRAnesMethodDesc</Value>
</Value>
<Value name="41">
<Value>RISRAnesLevelCode</Value>
</Value>
<Value name="42">
<Value>RISRAnesLevelDesc</Value>
</Value>
<Value name="43">
<Value>RISRAnesStartDateTime</Value>
</Value>
<Value name="44">
<Value>RISRAnesEndDateTime</Value>
</Value>
<Value name="45">
<Value>RISRSliceFrozenNo</Value>
</Value>
<Value name="46">
<Value>RISRInspMaterials</Value>
</Value>
<Value name="47">
<Value>RISRImmuneGrpNo</Value>
</Value>
<Value name="48">
<Value>RISRStatus</Value>
</Value>
<Value name="49">
<Value>RISRExamDocCode</Value>
</Value>
<Value name="50">
<Value>RISRExamDocDesc</Value>
</Value>
<Value name="51">
<Value>RISRExamDate</Value>
</Value>
<Value name="52">
<Value>RISRExamTime</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsRISReportResultD</DataLocation>
<DefaultData>EnsRISReportResultDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsRISReportResultD</IdLocation>
<IndexLocation>^Busi.ENS.EnsRISReportResultI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsRISReportResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
