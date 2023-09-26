/// creator: xbl
/// createdate: 20170925
/// description: 调查项目维护
Class DHCNMG.DB.MgSurveyStandard Extends %Persistent
{

Relationship Parref As DHCNMG.DB.MgSurveyItem [ Cardinality = parent, Inverse = StdChildSub ];

/// 描述
Property StandardDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Standard_Desc ];

/// 分值
Property StandardScore As %Float [ SqlColumnNumber = 5, SqlFieldName = Standard_Score ];

Storage Default
{
<Data name="MgSurveyStandardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StandardDesc</Value>
</Value>
<Value name="3">
<Value>StandardScore</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgSurveyStandardD</DataLocation>
<DefaultData>MgSurveyStandardDefaultData</DefaultData>
<IdLocation>{%%PARENT}("StdChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgSurveyStandardI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgSurveyStandardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
