/// creator: xbl
/// createdate: 20171016
/// description:病人调查明细
Class DHCNMG.Survey.MgPatSurveySub Extends %Persistent
{

Relationship Parref As DHCNMG.Survey.MgPatSurvey [ Cardinality = parent, Inverse = ChildSub ];

/// 评分项目
Property SurveyItemDR As DHCNMG.DB.MgSurveyItemSub [ SqlColumnNumber = 4, SqlFieldName = Survey_ItemDR ];

/// 评分
Property SurveyScoreDR As DHCNMG.DB.MgSurveyStandard [ SqlColumnNumber = 5, SqlFieldName = Survey_ScoreDR ];

Index Item On SurveyItemDR;

Index Score On (SurveyItemDR, SurveyScoreDR);

Storage Default
{
<Data name="MgPatSurveySubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SurveyItemDR</Value>
</Value>
<Value name="3">
<Value>SurveyScoreDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Survey.MgPatSurveySubD</DataLocation>
<DefaultData>MgPatSurveySubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Survey.MgPatSurveySubI</IndexLocation>
<StreamLocation>^DHCNMG.Survey.MgPatSurveySubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
