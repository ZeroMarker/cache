/// EPRmeta.CT.ORCOperation
/// 描述:门诊病历首页系统手术和操作代码别名表
/// 编写者:
/// 编写日期:
Class EPRmeta.CT.ORCOperationAlias Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 关联ORCOperation	
Property ORCOperatioID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1);

/// Text
Property ALIASText As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1);

Index IdxAliasText On ALIASText;

Storage Default
{
<Data name="ORCOperationAliasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ALIASText</Value>
</Value>
<Value name="3">
<Value>ORCOperatioID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CT.ORCOperationAliasD</DataLocation>
<DefaultData>ORCOperationAliasDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.CT.ORCOperationAliasD</IdLocation>
<IndexLocation>^DHCEPRM.CT.ORCOperationAliasI</IndexLocation>
<StreamLocation>^DHCEPRM.CT.ORCOperationAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
