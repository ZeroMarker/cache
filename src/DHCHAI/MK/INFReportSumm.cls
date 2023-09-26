/// 报告基本信息 + 扩展信息
Class DHCHAI.MK.INFReportSumm Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 易感因素("NINFInfInfFactors")
Property InfFactors As list Of DHCHAI.MK.INFDictionary;

/// 侵入性操作("NINFInfInvasiveOper")
Property InvasiveOperation As list Of DHCHAI.MK.INFDictionary;

/// 入住ICU("NINFInfICUBoolean")(是/否)
Property ICUBoolean As DHCHAI.MK.INFDictionary;

/// ICU科室("NINFInfICULocation")
Property ICULocation As DHCHAI.MK.INFDictionary;

/// 手术("NINFInfOprBoolean")(是/否)
Property OprBoolean As DHCHAI.MK.INFDictionary;

/// 病原学检验("NINFInfLabBoolean")(是/否)
Property LabBoolean As DHCHAI.MK.INFDictionary;

/// 使用抗菌药物("NINFInfAntiBoolean")(是/否)
Property AntiBoolean As DHCHAI.MK.INFDictionary;

/// 不良反应("NINFInfAdverseReaction")(有/无)
Property AdverseReaction As DHCHAI.MK.INFDictionary;

/// 二重感染("NINFInfSuperinfection")(有/无)
Property Superinfection As DHCHAI.MK.INFDictionary;

/// 新生儿出生体重(KG)
Property BornWeight As %String(TRUNCATE = 1);

/// 转科记录 指向PA_AdmTransaction
Property TransID As %String(TRUNCATE = 1);

/// 转入科室 指向CT_Loc
Property TransLoc As DHCHAI.MK.INFDictionary;

/// 入科来源 指向CT_Loc
Property TransFromLoc As DHCHAI.MK.INFDictionary;

/// 出科去向 指向CT_Loc
Property TransToLoc As DHCHAI.MK.INFDictionary;

/// 转入日期
Property TransInDate As %String;

/// 转出日期
Property TransOutDate As %String;

/// 转出ICU时状态(带管情况)("NINFICUOutICUStatus")
Property OutICUStatus As list Of DHCHAI.MK.INFDictionary;

/// 转出ICU48小时内状态(带管情况)("NINFICUOutICU48Status")
Property OutICU48Status As list Of DHCHAI.MK.INFDictionary;

/// 系统症状
Property SystemSymptom As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 局部症状/体征
Property LocalSymptom As %String(MAXLEN = 1000, TRUNCATE = 1);

/// Apache II评分
Property ApacheIIScore As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="INFReportSummState">
<Value name="1">
<Value>DiseasePrognosis</Value>
</Value>
<Value name="2">
<Value>DeathRelation</Value>
</Value>
<Value name="3">
<Value>DiagnosisBasis</Value>
</Value>
<Value name="4">
<Value>DiseaseCourse</Value>
</Value>
<Value name="5">
<Value>InfFactors</Value>
</Value>
<Value name="6">
<Value>InvasiveOperation</Value>
</Value>
<Value name="7">
<Value>ICUBoolean</Value>
</Value>
<Value name="8">
<Value>ICULocation</Value>
</Value>
<Value name="9">
<Value>OprBoolean</Value>
</Value>
<Value name="10">
<Value>LabBoolean</Value>
</Value>
<Value name="11">
<Value>AntiBoolean</Value>
</Value>
<Value name="12">
<Value>AdverseReaction</Value>
</Value>
<Value name="13">
<Value>Superinfection</Value>
</Value>
<Value name="14">
<Value>BornWeight</Value>
</Value>
<Value name="15">
<Value>TransID</Value>
</Value>
<Value name="16">
<Value>TransLoc</Value>
</Value>
<Value name="17">
<Value>TransFromLoc</Value>
</Value>
<Value name="18">
<Value>TransToLoc</Value>
</Value>
<Value name="19">
<Value>TransInDate</Value>
</Value>
<Value name="20">
<Value>TransOutDate</Value>
</Value>
<Value name="21">
<Value>OutICUStatus</Value>
</Value>
<Value name="22">
<Value>OutICU48Status</Value>
</Value>
<Value name="23">
<Value>SystemSymptom</Value>
</Value>
<Value name="24">
<Value>LocalSymptom</Value>
</Value>
<Value name="25">
<Value>ApacheIIScore</Value>
</Value>
</Data>
<State>INFReportSummState</State>
<StreamLocation>^DHCHAI.MK.INFReportSummS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
