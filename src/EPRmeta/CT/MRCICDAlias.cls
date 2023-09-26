/// EPRmeta.CT.MRCICDAlias
/// 描述:门诊病历首页系统就诊原因代码别名表
/// 编写者:
/// 编写日期:
Class EPRmeta.CT.MRCICDAlias Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 关联 EPRmeta.MRCICDDx
Property MRCICDDxID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1);

/// 别名
Property ALIASText As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1);

Index IdxAliasText On ALIASText;

Storage Default
{
<Data name="MRCICDAliasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ALIASText</Value>
</Value>
<Value name="3">
<Value>MRCICDDxID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CT.MRCICDAliasD</DataLocation>
<DefaultData>MRCICDAliasDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.CT.MRCICDAliasD</IdLocation>
<IndexLocation>^DHCEPRM.CT.MRCICDAliasI</IndexLocation>
<StreamLocation>^DHCEPRM.CT.MRCICDAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
