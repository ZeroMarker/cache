/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 药物临床试验严重不良事件报告-患者情况表
Class User.DHCDocPilotSAEPat Extends (%Persistent, User.Abstract)
{

Relationship PParRef As User.DHCDocPilotSAE [ Cardinality = parent, Inverse = ChildPat, Required, SqlFieldName = P_ParRef ];

/// 疾病
Property PDisease As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = P_Disease ];

/// 治疗药物
Property PDrug As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = P_Drug ];

/// 用法用量
Property PUseInfo As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = P_UseInfo ];

Storage Default
{
<Data name="DHCDocPilotSAEPatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PDisease</Value>
</Value>
<Value name="3">
<Value>PDrug</Value>
</Value>
<Value name="4">
<Value>PUseInfo</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildPat")</DataLocation>
<DefaultData>DHCDocPilotSAEPatDefaultData</DefaultData>
<IdLocation>^User.DHCDocPilotSAEC("ChildPat")</IdLocation>
<IndexLocation>^User.DHCDocPilotSAEPatI</IndexLocation>
<StreamLocation>^User.DHCDocPilotSAEPatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
