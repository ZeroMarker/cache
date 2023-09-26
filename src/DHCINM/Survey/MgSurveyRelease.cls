/// Creater:liwenzhen
/// Descriptions:调查发布表
/// Date:2020-07-18
Class DHCINM.Survey.MgSurveyRelease Extends %Persistent
{

/// 创建人
Property Creater As %String [ SqlColumnNumber = 2, SqlFieldName = Creater ];

/// 创建日期	
Property CreatDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 3, SqlFieldName = CreatDate ];

/// 创建时间	
Property CreatTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 4, SqlFieldName = CreatTime ];

/// 调查内容
Property SurveyContent As %String [ SqlColumnNumber = 5, SqlFieldName = SurveyContent ];

/// 调查标题
Property SurveyTitle As %String [ SqlColumnNumber = 6, SqlFieldName = SurveyTitle ];

/// 调查人员
Property SurveyPerson As list Of %String [ SqlColumnNumber = 7, SqlFieldName = SurveyPerson ];

/// 开始日期
Property StDate As %Date [ SqlColumnNumber = 8, SqlFieldName = StDate ];

/// 结束日期
Property EndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = EndDate ];

/// 备注说明
Property Remarks As %String [ SqlColumnNumber = 10, SqlFieldName = Remarks ];

/// 状态
Property Status As %String [ SqlColumnNumber = 11, SqlFieldName = Status ];

/// 调查任务发布类别 N:护士 P：患者 F：随访
Property Type As %String [ SqlColumnNumber = 12, SqlFieldName = Type ];

/// 调查病区
Property SurveyWard As list Of %String [ SqlColumnNumber = 13, SqlFieldName = SurveyWard ];

/// 回访开始天数
Property FStDays As %Integer [ SqlColumnNumber = 14, SqlFieldName = FStDays ];

/// 回访结束天数
Property FEndDays As %Integer [ SqlColumnNumber = 15, SqlFieldName = FEndDays ];

Index status On (Status, Type);

Index type On (Type, Status);

Index typeStDate On (Type, Status, StDate);

Index surveyContent On SurveyContent;

Storage Default
{
<Data name="MgSurveyReleaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Creater</Value>
</Value>
<Value name="3">
<Value>CreatDate</Value>
</Value>
<Value name="4">
<Value>CreatTime</Value>
</Value>
<Value name="5">
<Value>SurveyContent</Value>
</Value>
<Value name="6">
<Value>SurveyTitle</Value>
</Value>
<Value name="7">
<Value>SurveyPerson</Value>
</Value>
<Value name="8">
<Value>StDate</Value>
</Value>
<Value name="9">
<Value>EndDate</Value>
</Value>
<Value name="10">
<Value>Remarks</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>Type</Value>
</Value>
<Value name="13">
<Value>SurveyWard</Value>
</Value>
<Value name="14">
<Value>FStDays</Value>
</Value>
<Value name="15">
<Value>FEndDays</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Survey.MgSurveyReleaseD</DataLocation>
<DefaultData>MgSurveyReleaseDefaultData</DefaultData>
<IdLocation>^DHCINM.Survey.MgSurveyReleaseD</IdLocation>
<IndexLocation>^DHCINM.Survey.MgSurveyReleaseI</IndexLocation>
<StreamLocation>^DHCINM.Survey.MgSurveyReleaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
