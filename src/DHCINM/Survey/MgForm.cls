/// Creater:liwenzhen
/// Descriptions:调查表单填写父表
/// Date:2020-07-22
Class DHCINM.Survey.MgForm Extends %Persistent
{

Relationship ChildSub As DHCINM.Survey.MgFormSub [ Cardinality = children, Inverse = Parref ];

/// 创建人	
Property Creater As %String [ SqlColumnNumber = 2, SqlFieldName = Creater ];

/// 创建日期	
Property CreatDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 3, SqlFieldName = CreatDate ];

/// 创建时间	
Property CreatTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 4, SqlFieldName = CreatTime ];

/// 所属调查任务 DHCINM.Survey.MgSurveyRelease
Property ReleaseDR As %String [ SqlColumnNumber = 5, SqlFieldName = ReleaseDR ];

/// 所用调查表单 CF.DHCINM.DB.SurveyForm
Property SurveyDR As %String [ SqlColumnNumber = 6, SqlFieldName = SurveyDR ];

/// 被调查人 类型为N时为护士，类型为P时为患者，类型为F时为就诊号
Property SurveyPerson As %String [ SqlColumnNumber = 7, SqlFieldName = SurveyPerson ];

/// 病区
Property WardDR As %String [ SqlColumnNumber = 8, SqlFieldName = WardDR ];

/// 是否计分
Property IsCount As %String [ SqlColumnNumber = 9, SqlFieldName = IsCount ];

/// 表单类别 N:护士 P：患者 F：随访 R:正式护士轮转 T:调配
Property Type As %String [ SqlColumnNumber = 10, SqlFieldName = Type ];

/// 总分 
Property TotalScore As %String [ SqlColumnNumber = 11, SqlFieldName = TotalScore ];

/// 状态 A:未填写 N:已保存 Y:已提交
Property Status As %String [ SqlColumnNumber = 12, SqlFieldName = Status ];

/// 提交时间
Property SubmitDate As %Date [ SqlColumnNumber = 13, SqlFieldName = SubmitDate ];

/// 床号
Property BedNumber As %String [ SqlColumnNumber = 14, SqlFieldName = BedNumber ];

/// 随访状态 A:待随访 N:未完成 Y:已随访 
Property FollowUpStatus As %String(DISPLAYLIST = ",待随访,未完成,已随访", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",A,N,Y") [ SqlColumnNumber = 15, SqlFieldName = FollowUpStatus ];

/// 随访时间 
Property FollowUpDate As %Date [ SqlColumnNumber = 16, SqlFieldName = FollowUpDate ];

/// 问卷说明
Property Explain As %String(MAXLEN = 400) [ SqlColumnNumber = 17, SqlFieldName = Explain ];

/// 随访未完成情况
Property Situation As list Of %String(MAXLEN = 200) [ SqlColumnNumber = 18, SqlFieldName = Situation ];

/// 随访未完成情况选择
Property FollowUpAnswer As %String(MAXLEN = 200) [ SqlColumnNumber = 19, SqlFieldName = FollowUpAnswer ];

/// 评价所属发布表ID
Property EvaluateDR As %String [ SqlColumnNumber = 20, SqlFieldName = EvaluateDR ];

Index type On Type;

Index typeStatus On (Type, Status);

Index isCount On (Type, Status, IsCount);

Index typeWard On (Type, WardDR);

Index per On (ReleaseDR, SurveyPerson);

Index releaseDR On ReleaseDR;

Index evaluateDR On (Type, EvaluateDR);

Storage Default
{
<Data name="MgFormDefaultData">
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
<Value>ReleaseDR</Value>
</Value>
<Value name="6">
<Value>SurveyDR</Value>
</Value>
<Value name="7">
<Value>SurveyPerson</Value>
</Value>
<Value name="8">
<Value>WardDR</Value>
</Value>
<Value name="9">
<Value>IsCount</Value>
</Value>
<Value name="10">
<Value>Type</Value>
</Value>
<Value name="11">
<Value>TotalScore</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
<Value name="13">
<Value>SubmitDate</Value>
</Value>
<Value name="14">
<Value>BedNumber</Value>
</Value>
<Value name="15">
<Value>FollowUpStatus</Value>
</Value>
<Value name="16">
<Value>FollowUpDate</Value>
</Value>
<Value name="17">
<Value>Explain</Value>
</Value>
<Value name="18">
<Value>Situation</Value>
</Value>
<Value name="19">
<Value>FollowUpAnswer</Value>
</Value>
<Value name="20">
<Value>EvaluateDR</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Survey.MgFormD</DataLocation>
<DefaultData>MgFormDefaultData</DefaultData>
<IdLocation>^DHCINM.Survey.MgFormD</IdLocation>
<IndexLocation>^DHCINM.Survey.MgFormI</IndexLocation>
<StreamLocation>^DHCINM.Survey.MgFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
