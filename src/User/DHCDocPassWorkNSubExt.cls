/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 医生交班本子表扩展表
Class User.DHCDocPassWorkNSubExt Extends (%Persistent, User.Abstract)
{

/// ENID
Property ENID As User.DHCDocPassWorkNMain [ SqlColumnNumber = 2, SqlFieldName = E_NID ];

/// ESID
Property ESID As User.DHCDocPassWorkNSub [ SqlColumnNumber = 3, SqlFieldName = E_SID ];

/// 治疗方案(合并特殊疾病患者,泰和肿瘤)
Property EZLPlan As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = E_ZLPlan ];

/// 目前临床问题(危重症、特级、一级护理患者,泰和肿瘤)
Property EQuestion As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EQuestion ];

/// 主要处置措施(危重症、特级、一级护理患者,泰和肿瘤)
Property EMainAction As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = E_MainAction ];

Index ENID On ENID;

Index ESID On ESID;

Storage Default
{
<Data name="DHCDocPassWorkNSubExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ENID</Value>
</Value>
<Value name="3">
<Value>ESID</Value>
</Value>
<Value name="4">
<Value>EZLPlan</Value>
</Value>
<Value name="5">
<Value>EQuestion</Value>
</Value>
<Value name="6">
<Value>EMainAction</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocPassWorkNSubExtD</DataLocation>
<DefaultData>DHCDocPassWorkNSubExtDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkNSubExtD</IdLocation>
<IndexLocation>^User.DHCDocPassWorkNSubExtI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkNSubExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
