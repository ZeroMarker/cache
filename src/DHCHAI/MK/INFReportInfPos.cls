/// 感染部位
Class DHCHAI.MK.INFReportInfPos Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 感染部位
Property InfPos As DHCHAI.MK.INFDictionary;

/// 感染日期
Property InfDate As %String(TRUNCATE = 1);

/// 感染诊断
Property InfDiag As DHCHAI.MK.INFDictionary;

/// 感染科室
Property InfLoc As DHCHAI.MK.INFDictionary;

/// 与死亡关系
Property InfDeathRelation As DHCHAI.MK.INFDictionary;

/// 侵入性操作
Property InfPosOpr As list Of DHCHAI.MK.INFDictionary;

/// 感染转归日期 Add By LiYang 2013-05-18
Property InfEndDate As %String;

/// 感染转归 Add By LiYang 2013-05-19
Property InfEndResult As DHCHAI.MK.INFDictionary;

/// 诊断依据
Property DiagnosisBasis As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 感染性疾病病程
Property DiseaseCourse As %String(MAXLEN = 1000, TRUNCATE = 1);

Storage Default
{
<Data name="INFReportInfPosState">
<Value name="1">
<Value>InfPos</Value>
</Value>
<Value name="2">
<Value>InfDate</Value>
</Value>
<Value name="3">
<Value>InfDiag</Value>
</Value>
<Value name="4">
<Value>InfPosOpr</Value>
</Value>
<Value name="5">
<Value>InfEndDate</Value>
</Value>
<Value name="6">
<Value>InfEndResult</Value>
</Value>
<Value name="7">
<Value>InfLoc</Value>
</Value>
<Value name="8">
<Value>InfEffect</Value>
</Value>
<Value name="9">
<Value>InfDeathRelation</Value>
</Value>
<Value name="10">
<Value>DiagnosisBasis</Value>
</Value>
<Value name="11">
<Value>DiseaseCourse</Value>
</Value>
</Data>
<State>INFReportInfPosState</State>
<StreamLocation>^DHCHAI.MK.INFReportInfPosS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
