/// Creater:liwenzhen
/// Descriptions:调查表单填写子表
/// Date:2020-07-22
Class DHCINM.Survey.MgFormSub Extends %Persistent
{

Relationship Parref As DHCINM.Survey.MgForm [ Cardinality = parent, Inverse = ChildSub ];

/// 标题内容
Property QuesDesc As %String [ SqlColumnNumber = 2, SqlFieldName = QuesDesc ];

/// 题型
Property QuesType As %String [ SqlColumnNumber = 3, SqlFieldName = QuesType ];

/// 序号
Property Sort As %Integer [ SqlColumnNumber = 4, SqlFieldName = Sort ];

/// 是否必填
Property IsRequired As %String [ SqlColumnNumber = 5, SqlFieldName = IsRequired ];

/// 填写提示
Property WriteTips As %String [ SqlColumnNumber = 6, SqlFieldName = WriteTips ];

/// 跳题逻辑
Property JumpType As %String [ SqlColumnNumber = 7, SqlFieldName = JumpType ];

/// 排列方式
Property ArrangeType As %String [ SqlColumnNumber = 8, SqlFieldName = ArrangeType ];

/// 是否计分
Property IsCount As %String [ SqlColumnNumber = 9, SqlFieldName = IsCount ];

/// 备选项
Property QuesOption As list Of %String(MAXLEN = 200) [ SqlColumnNumber = 10, SqlFieldName = QuesOption ];

/// 答案
Property Answer As %String [ SqlColumnNumber = 11, SqlFieldName = Answer ];

/// 问题外键 CF.DHCINM.DB.SurveyFormSub
Property QuesDR As %String [ SqlColumnNumber = 12, SqlFieldName = QuesDR ];

/// 得分
Property QuesScore As %String [ SqlColumnNumber = 13, SqlFieldName = QuesScore ];

/// 滑动条最小值
Property QuesMin As %String [ SqlColumnNumber = 14, SqlFieldName = QuesMin ];

/// 滑动条最小值描述
Property QuesMinDesc As %String [ SqlColumnNumber = 15, SqlFieldName = QuesMinDesc ];

/// 滑动条最大值
Property QuesMax As %String [ SqlColumnNumber = 16, SqlFieldName = QuesMax ];

/// 滑动条最大值描述
Property QuesMaxDesc As %String [ SqlColumnNumber = 17, SqlFieldName = QuesMaxDesc ];

/// 输入框高度
Property InputHeight As %String [ SqlColumnNumber = 18, SqlFieldName = InputHeight ];

/// 输入框宽度度
Property InputWidth As %String [ SqlColumnNumber = 19, SqlFieldName = InputWidth ];

/// 答案(可以填空时输入的结果)
Property AnswerInput As %String [ SqlColumnNumber = 20, SqlFieldName = AnswerInput ];

/// 是否显示
Property ShowFlag As %String [ SqlColumnNumber = 21, SqlFieldName = ShowFlag ];

Index parr On (Parref, Sort);

Index quesDR On (Parref, QuesDR);

Storage Default
{
<Data name="MgFormSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QuesDesc</Value>
</Value>
<Value name="3">
<Value>QuesType</Value>
</Value>
<Value name="4">
<Value>Sort</Value>
</Value>
<Value name="5">
<Value>IsRequired</Value>
</Value>
<Value name="6">
<Value>WriteTips</Value>
</Value>
<Value name="7">
<Value>JumpType</Value>
</Value>
<Value name="8">
<Value>ArrangeType</Value>
</Value>
<Value name="9">
<Value>IsCount</Value>
</Value>
<Value name="10">
<Value>QuesOption</Value>
</Value>
<Value name="11">
<Value>Answer</Value>
</Value>
<Value name="12">
<Value>QuesDR</Value>
</Value>
<Value name="13">
<Value>QuesScore</Value>
</Value>
<Value name="14">
<Value>QuesMin</Value>
</Value>
<Value name="15">
<Value>QuesMinDesc</Value>
</Value>
<Value name="16">
<Value>QuesMax</Value>
</Value>
<Value name="17">
<Value>QuesMaxDesc</Value>
</Value>
<Value name="18">
<Value>InputHeight</Value>
</Value>
<Value name="19">
<Value>InputWidth</Value>
</Value>
<Value name="20">
<Value>AnswerInput</Value>
</Value>
<Value name="21">
<Value>ShowFlag</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Survey.MgFormSubD</DataLocation>
<DefaultData>MgFormSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.Survey.MgFormSubI</IndexLocation>
<StreamLocation>^DHCINM.Survey.MgFormSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
