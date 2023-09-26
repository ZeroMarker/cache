/// 
/// 
/// Description：优良事件
Class DHCNMG.Event.MgExcellent Extends %Persistent
{

/// 病区
Property ExcellentWard As %String [ SqlColumnNumber = 2, SqlFieldName = Excellent_Ward ];

/// 日期
Property ExcellentDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Excellent_Date ];

/// 时间
Property ExcellentTime As %Time [ SqlColumnNumber = 4, SqlFieldName = Excellent_Time ];

/// 当事人
Property ExcellentNurse As %String [ SqlColumnNumber = 5, SqlFieldName = Excellent_Nurse ];

/// 填报人
Property ExcellentUser As %String [ SqlColumnNumber = 6, SqlFieldName = Excellent_User ];

/// 涉及患者  病人就诊id
Property ExcellentPat As %String [ SqlColumnNumber = 7, SqlFieldName = Excellent_Pat ];

/// 事件发生的经过
Property ExcellentProcess As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = Excellent_Process ];

/// 分级
Property ExcellentGrade As %String [ SqlColumnNumber = 9, SqlFieldName = Excellent_Grade ];

/// 评定日期
Property GradeDate As %Date [ SqlColumnNumber = 10, SqlFieldName = Grade_Date ];

/// 意见
Property Opinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = Opinion ];

/// 状态 【O：作废(删除) N：保存 Y：提交 A：审核】
Property Status As %String [ SqlColumnNumber = 12, SqlFieldName = Status ];

/// 患者住院号
Property ExcellentPatNo As %String [ SqlColumnNumber = 13, SqlFieldName = Excellent_PatNo ];

/// 解决方式
Property ExcellentSolve As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = Excellent_Solve ];

/// 事件反思
Property ExcellentIntro As %String(MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = Excellent_Intro ];

/// 事件名称
Property ExcellentTitle As %String(MAXLEN = 100) [ SqlColumnNumber = 16, SqlFieldName = Excellent_Title ];

/// 事件当前处理进度(护士0->护士长1->科护士长2->护理部3依次审核)
Property ExcellentHandle As %String [ SqlColumnNumber = 17, SqlFieldName = Excellent_Handle ];

Index status On (Status, ExcellentWard);

Index level On ExcellentHandle;

Index creator On ExcellentUser;

Storage Default
{
<Data name="MgExcellentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExcellentWard</Value>
</Value>
<Value name="3">
<Value>ExcellentDate</Value>
</Value>
<Value name="4">
<Value>ExcellentTime</Value>
</Value>
<Value name="5">
<Value>ExcellentNurse</Value>
</Value>
<Value name="6">
<Value>ExcellentUser</Value>
</Value>
<Value name="7">
<Value>ExcellentPat</Value>
</Value>
<Value name="8">
<Value>ExcellentProcess</Value>
</Value>
<Value name="9">
<Value>ExcellentGrade</Value>
</Value>
<Value name="10">
<Value>GradeDate</Value>
</Value>
<Value name="11">
<Value>Opinion</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
<Value name="13">
<Value>ExcellentPatNo</Value>
</Value>
<Value name="14">
<Value>ExcellentSolve</Value>
</Value>
<Value name="15">
<Value>ExcellentIntro</Value>
</Value>
<Value name="16">
<Value>ExcellentTitle</Value>
</Value>
<Value name="17">
<Value>ExcellentHandle</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Event.MgExcellentD</DataLocation>
<DefaultData>MgExcellentDefaultData</DefaultData>
<IdLocation>^DHCNMG.Event.MgExcellentD</IdLocation>
<IndexLocation>^DHCNMG.Event.MgExcellentI</IndexLocation>
<StreamLocation>^DHCNMG.Event.MgExcellentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
