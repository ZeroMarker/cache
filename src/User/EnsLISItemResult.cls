/// 检验项目结果表
Class User.EnsLISItemResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = LISIR_RowID, SqlRowIdPrivate, SqlTableName = Ens_LISItemResult ]
{

Index LISITEMRESULTPKey On LISIRRowID [ PrimaryKey, Type = index, Unique ];

Index LISIRReportIDIndex On (LISIRReportID, LISIRShowSeq) [ SqlName = INDEX_LISIRReportID, Type = index ];

Index LISIRItemCodeIndex On (LISIRPatientID, LISIRItemCode, LISIRTestDate, LISIRTestTime);

Index LISIRInterCodeIndex On (LISIRPatientID, LISIRInterCode, LISIRTestDate, LISIRTestTime);

Index LISIRUpdateDateTimeIndex On (LISIRUpdateDate, LISIRUpdateTime);

Index IndexReportItem On (LISIRReportID, LISIRItemCode) [ SqlName = Index_ReportItem, Type = index, Unique ];

Index LISIRAdmItemIndex On (LISIRVisitNumber, LISIRItemCode, LISIRTestDate, LISIRTestTime);

ForeignKey FKLISITEMRESULTREFERENCEREPORTID(LISIRReportID) References User.EnsLISReportResult(LISREPORTRESULTPKey) [ SqlName = FK_LISITEMRESULT_REFERENCE_REPORTID ];

/// ForeignKey FKLISITEMRESULTREFERENCELISITEMCODE(LISIRItemCode) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_LISITEMRESULT_REFERENCE_LISITEMCODE ];
/// 序列ID
Property LISIRRowID As %Library.Integer [ InitialExpression = {$I(^Busi.ENS.EnsLISItemResultC)}, Required, SqlColumnNumber = 2, SqlFieldName = LISIR_RowID ];

/// 报告ID
Property LISIRReportID As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 3, SqlFieldName = LISIR_ReportID ];

/// 患者ID
Property LISIRPatientID As User.PAPatMas [ SqlColumnNumber = 4, SqlFieldName = LISIR_PatientID ];

/// 就诊号
Property LISIRVisitNumber As User.PAAdm [ SqlColumnNumber = 5, SqlFieldName = LISIR_VisitNumber ];

/// 化验项目代码
Property LISIRItemCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 6, SqlFieldName = LISIR_ItemCode ];

/// 化验项目名称
Property LISIRItemDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 7, SqlFieldName = LISIR_ItemDesc ];

/// 结果
Property LISIRResult As %Library.String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = LISIR_Result ];

/// 单位
Property LISIRUint As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 9, SqlFieldName = LISIR_Uint ];

/// 定性结果
Property LISIRTextResult As %Library.String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = LISIR_TextResult ];

/// 扩展结果
Property LISIRExtraResult As %Library.String(COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 11, SqlFieldName = LISIR_ExtraResult ];

/// 结果说明
Property LISIRResultExplain As %Library.String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 12, SqlFieldName = LISIR_ResultExplain ];

/// 异常标志
Property LISIRAbnormalFlags As %Library.String(COLLATION = "EXACT", MAXLEN = 5) [ SqlColumnNumber = 13, SqlFieldName = LISIR_AbnormalFlags ];

/// 参考范围
Property LISIRRanges As %Library.String(COLLATION = "EXACT", MAXLEN = 300) [ SqlColumnNumber = 14, SqlFieldName = LISIR_Ranges ];

/// 检测方法
Property LISIRTestMethod As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 15, SqlFieldName = LISIR_TestMethod ];

/// 检测仪器
Property LISIRTestMachine As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 16, SqlFieldName = LISIR_TestMachine ];

/// 检测人代码
Property LISIRTestUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 17, SqlFieldName = LISIR_TestUserCode ];

/// 检测人描述
Property LISIRTestUserDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 18, SqlFieldName = LISIR_TestUserDesc ];

/// 显示序号（在同一报告ID下自增）
Property LISIRShowSeq As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 19, SqlFieldName = LISIR_ShowSeq ];

/// 检测日期
Property LISIRTestDate As %Library.Date [ SqlColumnNumber = 20, SqlFieldName = LISIR_TestDate ];

/// 检测时间
Property LISIRTestTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = LISIR_TestTime ];

/// 细菌计数
Property LISIRCount As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 22, SqlFieldName = LISIR_Count ];

/// 专家规则
Property LISIRExpertRule As %Library.String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 23, SqlFieldName = LISIR_ExpertRule ];

/// 备注
Property LISIRRemark As %Library.String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 24, SqlFieldName = LISIR_Remark ];

/// 时间戳日期
Property LISIRUpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, Required, SqlColumnNumber = 25, SqlFieldName = LISIR_UpdateDate ];

/// 时间戳时间
Property LISIRUpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, Required, SqlColumnNumber = 26, SqlFieldName = LISIR_UpdateTime ];

/// 国际代码
Property LISIRInterCode As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 27, SqlFieldName = LISIR_InterCode ];

/// 医嘱号
Property LISIROrderItemID As User.OEOrdItem [ SqlColumnNumber = 28, SqlFieldName = LISIR_OrderItemID ];

/// 检测状态（1创建，2上传，3结果，4复查,0其他）
Property LISIRAssayStatus As %Library.String(COLLATION = "EXACT", MAXLEN = 1) [ SqlColumnNumber = 29, SqlFieldName = LISIR_AssayStatus ];

/// 复查次数
Property LISIRReAssayNum As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ SqlColumnNumber = 30, SqlFieldName = LISIR_ReAssayNum ];

/// 结果类别
Property LISIRResClass As %Library.String(COLLATION = "EXACT", MAXLEN = 1) [ SqlColumnNumber = 31, SqlFieldName = LISIR_ResClass ];

/// 细菌（预报告结果细菌名称）
Property LISIROrganism As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 32, SqlFieldName = LISIR_Organism ];

/// 复查号
Property LISIRReAssayNumber As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 33, SqlFieldName = LISIR_ReAssayNumber ];

/// 是否多耐菌(1:true,0:false)
Property LISIRMultipleResistant As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 34, SqlFieldName = LISIR_MultipleResistant ];

/// 多耐菌群
Property LISIRMultipleResChild As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 35, SqlFieldName = LISIR_MultipleResChild ];

/// 是否危急
Property LISIRWarnCode As %String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 36, SqlFieldName = LISIR_WarnCode ];

/// 是否条件致病菌
Property LISIRCondPathogen As %String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 37, SqlFieldName = LISIR_CondPathogen ];

/// 药敏标记
Property LISIREsblFlag As %String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 38, SqlFieldName = LISIR_EsblFlag ];

Storage Default
{
<Data name="EnsLISItemResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LISIRRowID</Value>
</Value>
<Value name="3">
<Value>LISIRReportID</Value>
</Value>
<Value name="4">
<Value>LISIRPatientID</Value>
</Value>
<Value name="5">
<Value>LISIRVisitNumber</Value>
</Value>
<Value name="6">
<Value>LISIRItemCode</Value>
</Value>
<Value name="7">
<Value>LISIRItemDesc</Value>
</Value>
<Value name="8">
<Value>LISIRResult</Value>
</Value>
<Value name="9">
<Value>LISIRUint</Value>
</Value>
<Value name="10">
<Value>LISIRTextResult</Value>
</Value>
<Value name="11">
<Value>LISIRExtraResult</Value>
</Value>
<Value name="12">
<Value>LISIRResultExplain</Value>
</Value>
<Value name="13">
<Value>LISIRAbnormalFlags</Value>
</Value>
<Value name="14">
<Value>LISIRRanges</Value>
</Value>
<Value name="15">
<Value>LISIRTestMethod</Value>
</Value>
<Value name="16">
<Value>LISIRTestMachine</Value>
</Value>
<Value name="17">
<Value>LISIRTestUserCode</Value>
</Value>
<Value name="18">
<Value>LISIRTestUserDesc</Value>
</Value>
<Value name="19">
<Value>LISIRShowSeq</Value>
</Value>
<Value name="20">
<Value>LISIRTestDate</Value>
</Value>
<Value name="21">
<Value>LISIRTestTime</Value>
</Value>
<Value name="22">
<Value>LISIRCount</Value>
</Value>
<Value name="23">
<Value>LISIRExpertRule</Value>
</Value>
<Value name="24">
<Value>LISIRRemark</Value>
</Value>
<Value name="25">
<Value>LISIRUpdateDate</Value>
</Value>
<Value name="26">
<Value>LISIRUpdateTime</Value>
</Value>
<Value name="27">
<Value>LISIRInterCode</Value>
</Value>
<Value name="28">
<Value>LISIROrderItemID</Value>
</Value>
<Value name="29">
<Value>LISIRAssayStatus</Value>
</Value>
<Value name="30">
<Value>LISIRReAssayNum</Value>
</Value>
<Value name="31">
<Value>LISIRResClass</Value>
</Value>
<Value name="32">
<Value>LISIROrganism</Value>
</Value>
<Value name="33">
<Value>LISIRReAssayNumber</Value>
</Value>
<Value name="34">
<Value>LISIRMultipleResistant</Value>
</Value>
<Value name="35">
<Value>LISIRMultipleResChild</Value>
</Value>
<Value name="36">
<Value>LISIRWarnCode</Value>
</Value>
<Value name="37">
<Value>LISIRCondPathogen</Value>
</Value>
<Value name="38">
<Value>LISIREsblFlag</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsLISItemResultD</DataLocation>
<DefaultData>EnsLISItemResultDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsLISItemResultD</IdLocation>
<IndexLocation>^Busi.ENS.EnsLISItemResultI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsLISItemResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
