/// creator: xbl
/// createdate: 20171016
/// description:病人调查
Class DHCNMG.Survey.MgPatSurvey Extends %Persistent
{

Relationship ChildSub As DHCNMG.Survey.MgPatSurveySub [ Cardinality = children, Inverse = Parref ];

/// 病人
Property SurveyAdmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = Survey_AdmDR ];

/// 病区
Property SurveyWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = Survey_WardDR ];

/// 床号
Property SurveyBedDR As User.PACBed [ SqlColumnNumber = 4, SqlFieldName = Survey_BedDR ];

/// 调查内容
Property SurveyItemDR As DHCNMG.DB.MgSurveyItem [ SqlColumnNumber = 5, SqlFieldName = Survey_ItemDR ];

/// 总分
Property SurveyScore As %Float [ SqlColumnNumber = 6, SqlFieldName = Survey_Score ];

/// 其他建议或意见
Property SurveySuggest As %String(MAXLEN = 10000) [ SqlColumnNumber = 7, SqlFieldName = Survey_Suggest ];

/// 创建人
Property SurveyCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 8, SqlFieldName = Survey_CrtUSer ];

/// 创建日期
Property SurveyCrtDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Survey_CrtDate ];

/// 创建时间
Property SurveyCrtTime As %Time [ SqlColumnNumber = 10, SqlFieldName = Survey_CrtTime ];

Index Patient On (SurveyAdmDR, SurveyItemDR);

Index Ward On (SurveyWardDR, SurveyItemDR);

Storage Default
{
<Data name="MgPatSurveyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>SurveyWardDR</Value>
</Value>
<Value name="4">
<Value>SurveyScore</Value>
</Value>
<Value name="5">
<Value>SurveyRemark</Value>
</Value>
<Value name="6">
<Value>SurveyCrtUser</Value>
</Value>
<Value name="7">
<Value>SurveyCrtDate</Value>
</Value>
<Value name="8">
<Value>SurveyCrtTime</Value>
</Value>
<Value name="9">
<Value>SurveyBedDR</Value>
</Value>
<Value name="10">
<Value>SurveyItemDR</Value>
</Value>
<Value name="11">
<Value>SurveyAdmDR</Value>
</Value>
<Value name="12">
<Value>SurveySuggest</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Survey.MgPatSurveyD</DataLocation>
<DefaultData>MgPatSurveyDefaultData</DefaultData>
<IdLocation>^DHCNMG.Survey.MgPatSurveyD</IdLocation>
<IndexLocation>^DHCNMG.Survey.MgPatSurveyI</IndexLocation>
<StreamLocation>^DHCNMG.Survey.MgPatSurveyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
