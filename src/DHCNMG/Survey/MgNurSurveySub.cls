Class DHCNMG.Survey.MgNurSurveySub Extends %Persistent
{

Relationship Parref As DHCNMG.Survey.MgNurSurveyList [ Cardinality = parent, Inverse = ChildSub ];

/// 评分项目
Property SurveyItemDR As DHCNMG.DB.MgSurveyItemSub [ SqlColumnNumber = 4, SqlFieldName = Survey_ItemDR ];

/// 评分
Property SurveyScoreDR As DHCNMG.DB.MgSurveyStandard [ SqlColumnNumber = 5, SqlFieldName = Survey_ScoreDR ];

Index Item On SurveyItemDR;

Index Score On (SurveyItemDR, SurveyScoreDR);

Storage Default
{
<Data name="MgNurSurveySubDefaultData">
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
<DataLocation>^DHCNMG.Survey.MgNurSurveySubD</DataLocation>
<DefaultData>MgNurSurveySubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Survey.MgNurSurveySubI</IndexLocation>
<StreamLocation>^DHCNMG.Survey.MgNurSurveySubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
