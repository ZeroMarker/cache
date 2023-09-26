/// creator: xbl
/// createdate: 20171009
/// description:护士调查
Class DHCNMG.Survey.MgNurSurvey Extends %Persistent
{

/// 任务单号
Property SurveyCode As %String [ SqlColumnNumber = 2, SqlFieldName = Survey_Code ];

/// 任务描述
Property SurveyDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Survey_Desc ];

/// 调查内容
Property SurveyContent As DHCNMG.DB.MgSurveyItem [ SqlColumnNumber = 4, SqlFieldName = Survey_Content ];

/// 调查形式
Property SurveyFormDR As DHCNMG.Set.MgSysParamSub [ SqlColumnNumber = 5, SqlFieldName = Survey_FormDR ];

/// 调查范围类型 A:片区 L:科室 W:病区 R:角色 
Property SurveyLimitType As %String [ SqlColumnNumber = 6, SqlFieldName = Survey_LimitType ];

/// 调查范围
Property SurveyLimit As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Survey_Limit ];

/// 开始日期
Property SurveyStDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Survey_StDate ];

/// 结束日期
Property SurveyEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Survey_EndDate ];

/// 备注说明
Property SurveyRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = Survey_Remark ];

/// 状态
Property SurveyStatus As %String [ SqlColumnNumber = 11, SqlFieldName = Survey_Status ];

/// 创建者
Property SurveyCrtUser As %String [ SqlColumnNumber = 12, SqlFieldName = Survey_CrtUser ];

/// 创建日期
Property SurveyCrtDate As %Date [ SqlColumnNumber = 13, SqlFieldName = Survey_CrtDate ];

/// 创建时间
Property SurveyCrtTime As %Time [ SqlColumnNumber = 14, SqlFieldName = Survey_CrtTime ];

Index Code On SurveyCode;

Index Type On SurveyContent;

Storage Default
{
<Data name="MgNurSurveyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SurveyCode</Value>
</Value>
<Value name="3">
<Value>SurveyDesc</Value>
</Value>
<Value name="4">
<Value>SurveyTypeDR</Value>
</Value>
<Value name="5">
<Value>SurveyFormDR</Value>
</Value>
<Value name="6">
<Value>SurveyLimitType</Value>
</Value>
<Value name="7">
<Value>SurveyLimit</Value>
</Value>
<Value name="8">
<Value>SurveyStDate</Value>
</Value>
<Value name="9">
<Value>SurveyEndDate</Value>
</Value>
<Value name="10">
<Value>SurveyRemark</Value>
</Value>
<Value name="11">
<Value>SurveyCrtUser</Value>
</Value>
<Value name="12">
<Value>SurveyCrtDate</Value>
</Value>
<Value name="13">
<Value>SurveyCrtTime</Value>
</Value>
<Value name="14">
<Value>SurveyContent</Value>
</Value>
<Value name="15">
<Value>SurveyStatus</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Survey.MgNurSurveyD</DataLocation>
<DefaultData>MgNurSurveyDefaultData</DefaultData>
<IdLocation>^DHCNMG.Survey.MgNurSurveyD</IdLocation>
<IndexLocation>^DHCNMG.Survey.MgNurSurveyI</IndexLocation>
<StreamLocation>^DHCNMG.Survey.MgNurSurveyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
