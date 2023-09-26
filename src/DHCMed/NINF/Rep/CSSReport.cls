/// 名称: DHCMed.NINF.Rep.CSSReport
/// 描述: 横断面调查(Cross-Section Study) 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-11-30
Class DHCMed.NINF.Rep.CSSReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 调查日期
Property ExamDate As %Date [ Required ];

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1) [ Required ];

/// 临床诊断
Property ClinDiagnos As list Of DHCMed.NINF.Rep.CSSReportICD;

/// 感染信息(感染类型+感染部位+病原体)
Property InfPos As list Of DHCMed.NINF.Rep.CSSReportPos;

/// HbsAg阳性("NINFCSSRepIsHbsAg")
Property IsHbsAg As DHCMed.SS.Dictionary;

/// 抗-HCV阳性("NINFCSSRepIsHCV")
Property IsHCV As DHCMed.SS.Dictionary;

/// 抗-HIV阳性("NINFCSSRepIsHIV")
Property IsHIV As DHCMed.SS.Dictionary;

/// 是否使用抗菌药物("NINFCSSRepIsUserAnti")
Property IsUserAnti As DHCMed.SS.Dictionary;

/// 用药目的("NINFCSSRepMedPurpose")
Property MedPurpose As DHCMed.SS.Dictionary;

/// 联合用药("NINFCSSRepCombinedMed")
Property CombinedMed As DHCMed.SS.Dictionary;

/// 治疗用药是否送检("NINFCSSRepIsSubmission")
Property IsSubmission As DHCMed.SS.Dictionary;

/// 是否手术("NINFCSSRepIsOperation")
Property IsOperation As DHCMed.SS.Dictionary;

/// 术前应用抗生素("NINFCSSRepIsPreoperAnti")
Property IsPreoperAnti As DHCMed.SS.Dictionary;

/// 手术切口类型("NINFCSSRepOperCuteType")
Property OperCuteType As DHCMed.SS.Dictionary;

/// 外科围术期用药("NINFCSSRepIsPerioperAnti")
Property IsPerioperAnti As DHCMed.SS.Dictionary;

/// 有无泌尿道插管("NINFCSSRepIsHaveUC")
Property IsHaveUC As DHCMed.SS.Dictionary;

/// 是否泌尿道感染前48h内有泌尿道插管("NINFCSSRepIs48HourUC")
Property Is48HourUC As DHCMed.SS.Dictionary;

/// 有无动静脉插管("NINFCSSRepIs48HourPICC")
Property IsHavePICC As DHCMed.SS.Dictionary;

/// 是否血流感染前48h内有动静脉插管("NINFCSSRepIs48HourPICC")
Property Is48HourPICC As DHCMed.SS.Dictionary;

/// 有无气管切开("NINFCSSRepIsHaveTC")
Property IsHaveTC As DHCMed.SS.Dictionary;

/// 是否肺部感染前48h内有气管切开("NINFCSSRepIs48HourTC")
Property Is48HourTC As DHCMed.SS.Dictionary;

/// 有无使用呼吸机("NINFCSSRepIsHaveVAP")
Property IsHaveVAP As DHCMed.SS.Dictionary;

/// 是否肺部感染前48h内有使用呼吸机("NINFCSSRepIs48HourVAP")
Property Is48HourVAP As DHCMed.SS.Dictionary;

/// 有无血液透析("NINFCSSRepIsHaveCHD")
Property IsHaveCHD As DHCMed.SS.Dictionary;

/// 报告日期
Property ReportDate As %String(TRUNCATE = 1);

/// 报告时间
Property ReportTime As %String(TRUNCATE = 1);

/// 报告科室
Property ReportLoc As %String(TRUNCATE = 1);

/// 报告人
Property ReportUser As %String(TRUNCATE = 1);

/// 调查日期+就诊 唯一索引
Index IndexExamDateAdm On (ExamDate, EpisodeID) [ Unique ];

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExamDate</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>ClinDiagnos</Value>
</Value>
<Value name="5">
<Value>InfPos</Value>
</Value>
<Value name="6">
<Value>IsHbsAg</Value>
</Value>
<Value name="7">
<Value>IsHCV</Value>
</Value>
<Value name="8">
<Value>IsHIV</Value>
</Value>
<Value name="9">
<Value>IsUserAnti</Value>
</Value>
<Value name="10">
<Value>MedPurpose</Value>
</Value>
<Value name="11">
<Value>CombinedMed</Value>
</Value>
<Value name="12">
<Value>IsSubmission</Value>
</Value>
<Value name="13">
<Value>IsOperation</Value>
</Value>
<Value name="14">
<Value>IsPreoperAnti</Value>
</Value>
<Value name="15">
<Value>OperCuteType</Value>
</Value>
<Value name="16">
<Value>IsPerioperAnti</Value>
</Value>
<Value name="17">
<Value>IsHaveUC</Value>
</Value>
<Value name="18">
<Value>Is48HourUC</Value>
</Value>
<Value name="19">
<Value>IsHavePICC</Value>
</Value>
<Value name="20">
<Value>Is48HourPICC</Value>
</Value>
<Value name="21">
<Value>IsHaveTC</Value>
</Value>
<Value name="22">
<Value>Is48HourTC</Value>
</Value>
<Value name="23">
<Value>IsHaveVAP</Value>
</Value>
<Value name="24">
<Value>Is48HourVAP</Value>
</Value>
<Value name="25">
<Value>IsHaveCHD</Value>
</Value>
<Value name="26">
<Value>ReportDate</Value>
</Value>
<Value name="27">
<Value>ReportTime</Value>
</Value>
<Value name="28">
<Value>ReportLoc</Value>
</Value>
<Value name="29">
<Value>ReportUser</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF("CSSRep")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF("CSSRep")</IdLocation>
<IndexLocation>^DHCMed.NINFi("CSSRep",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.CSSReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
