/// 13、拼音别名表DHC_HM_CAlias
Class User.DHCHMCAlias Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right ]
{

Parameter ClassName = "User.DHCHMCAlias";

/// 	A_Type	类型			NOTNULL		见设置说明表
Property AType As %String [ Required ];

/// 	A_SourceID		Text		
Property ASourceID As %String;

/// 4	A_Value	拼音	Text	30	NOT NULL		DHC_HM_CQuestionnaire
Property AValue As %String [ Required ];

Index AValueIndex On (AType, AValue);

Index ASourceIDIndex On (AType, ASourceID);

ClassMethod ttt()
{
	w ..%ClassName(1)
	q
}

Storage Default
{
<Data name="DHCHMCAliasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ASourceID</Value>
</Value>
<Value name="3">
<Value>AType</Value>
</Value>
<Value name="4">
<Value>AValue</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCAliasD</DataLocation>
<DefaultData>DHCHMCAliasDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCAliasD</IdLocation>
<IndexLocation>^User.DHCHMCAliasI</IndexLocation>
<StreamLocation>^User.DHCHMCAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
