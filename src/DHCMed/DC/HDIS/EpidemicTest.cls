/// 名称 : DHCMed.DC.HDIS.EpidemicTest
/// 说明 : 传染病病原学指标检测
Class DHCMed.DC.HDIS.EpidemicTest Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 乙型病毒性肝炎HBsAg（阳性、弱阳性、阴性）
Property HBsAg As %String(MAXLEN = 100, TRUNCATE = 1);

/// 乙型病毒性肝炎HBsAb（阳性、弱阳性、阴性）
Property HBsAb As %String(MAXLEN = 100, TRUNCATE = 1);

/// 乙型病毒性肝炎HBcAb（阳性、弱阳性、阴性）
Property HBcAb As %String(MAXLEN = 100, TRUNCATE = 1);

/// 乙型病毒性肝炎HBeAg（阳性、弱阳性、阴性）
Property HBeAg As %String(MAXLEN = 100, TRUNCATE = 1);

/// 乙型病毒性肝炎HBeAb（阳性、弱阳性、阴性）
Property HBeAb As %String(MAXLEN = 100, TRUNCATE = 1);

/// 乙型病毒性肝炎HBV DNA（拷贝/ml）
Property HBVDNA As %String(MAXLEN = 100, TRUNCATE = 1);

/// 丙型病毒性肝炎HCVAb（阳性、弱阳性、阴性）
Property HCVAb As %String(MAXLEN = 100, TRUNCATE = 1);

/// 丙型病毒性肝炎HCV RNA（拷贝/ml）
Property HCVRNA As %String(MAXLEN = 100, TRUNCATE = 1);

/// HIV（有/无）
Property HIV As %String(MAXLEN = 100, TRUNCATE = 1);

/// 梅毒（有/无）
Property Syphilis As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其他传染病
Property OtherEpd As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="EpidemicTestState">
<Value name="1">
<Value>HBsAg</Value>
</Value>
<Value name="2">
<Value>HBsAb</Value>
</Value>
<Value name="3">
<Value>HBcAb</Value>
</Value>
<Value name="4">
<Value>HBeAg</Value>
</Value>
<Value name="5">
<Value>HBeAb</Value>
</Value>
<Value name="6">
<Value>HBVDNA</Value>
</Value>
<Value name="7">
<Value>HCVAb</Value>
</Value>
<Value name="8">
<Value>HCVRNA</Value>
</Value>
<Value name="9">
<Value>HIV</Value>
</Value>
<Value name="10">
<Value>Syphilis</Value>
</Value>
<Value name="11">
<Value>OtherEpd</Value>
</Value>
</Data>
<State>EpidemicTestState</State>
<StreamLocation>^DHCMed.DC.HDIS.EpidemicTestS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
