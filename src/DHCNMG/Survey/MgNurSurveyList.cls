/// creator: xbl
/// createdate: 20171010
/// description:护士调查
Class DHCNMG.Survey.MgNurSurveyList Extends %Persistent
{

Relationship ChildSub As DHCNMG.Survey.MgNurSurveySub [ Cardinality = children, Inverse = Parref ];

/// 调查安排
Property SurveyDR As DHCNMG.Survey.MgNurSurvey [ SqlColumnNumber = 2, SqlFieldName = Survey_DR ];

/// 护士
Property SurveyPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 3, SqlFieldName = Survey_PerDR ];

/// 病区
Property SurveyWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 4, SqlFieldName = Survey_WardDR ];

/// 总分
Property SurveyScore As %Float [ SqlColumnNumber = 5, SqlFieldName = Survey_Score ];

/// 状态
Property SurveyStatus As %String [ SqlColumnNumber = 6, SqlFieldName = Survey_Status ];

/// 创建日期
Property SurveyCrtDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Survey_CrtDate ];

/// 创建时间
Property SurveyCrtTime As %Time [ SqlColumnNumber = 8, SqlFieldName = Survey_CrtTime ];

/// 意见建议
Property SurveySuggest As %String(MAXLEN = 10000) [ SqlColumnNumber = 9, SqlFieldName = Survey_Suggest ];

Index SurveyPerson On (SurveyDR, SurveyPerDR);

Index SurveyWard On (SurveyDR, SurveyWardDR);

Storage Default
{
<Data name="MgNurSurveyListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SurveyDR</Value>
</Value>
<Value name="3">
<Value>SurveyPerDR</Value>
</Value>
<Value name="4">
<Value>SurveyWardDR</Value>
</Value>
<Value name="5">
<Value>SurveyScore</Value>
</Value>
<Value name="6">
<Value>SurveyStatus</Value>
</Value>
<Value name="7">
<Value>SurveyDate</Value>
</Value>
<Value name="8">
<Value>SurveyTime</Value>
</Value>
<Value name="9">
<Value>SurveyCrtDate</Value>
</Value>
<Value name="10">
<Value>SurveyCrtTime</Value>
</Value>
<Value name="11">
<Value>SurveySuggest</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Survey.MgNurSurveyListD</DataLocation>
<DefaultData>MgNurSurveyListDefaultData</DefaultData>
<IdLocation>^DHCNMG.Survey.MgNurSurveyListD</IdLocation>
<IndexLocation>^DHCNMG.Survey.MgNurSurveyListI</IndexLocation>
<StreamLocation>^DHCNMG.Survey.MgNurSurveyListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
