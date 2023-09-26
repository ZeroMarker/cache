/// creator: xbl
/// createdate: 20170925
/// description: 调查子项
Class DHCNMG.DB.MgSurveyItemSub Extends %Persistent
{

Relationship Parref As DHCNMG.DB.MgSurveyItem [ Cardinality = parent, Inverse = ChildSub ];

/// 项目code
Property ItemCode As %String [ SqlColumnNumber = 2, SqlFieldName = Item_Code ];

/// 项目desc 
Property ItemDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Item_Desc ];

Index Code On ItemCode;

Index Desc On ItemDesc;

Storage Default
{
<Data name="MgSurveyItemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemDesc</Value>
</Value>
<Value name="4">
<Value>ItemParDR</Value>
</Value>
<Value name="5">
<Value>ItemScore</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgSurveyItemSubD</DataLocation>
<DefaultData>MgSurveyItemSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgSurveyItemSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgSurveyItemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
