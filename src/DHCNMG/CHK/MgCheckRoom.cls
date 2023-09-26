/// Creater:guozj
/// Descriptions:质控查房父表
/// Date:2017-09-22
Class DHCNMG.CHK.MgCheckRoom Extends %Persistent
{

Relationship ChildSub As DHCNMG.CHK.MgCheckRoomSub [ Cardinality = children, Inverse = Parref ];

/// 被评病区
Property ScoreWard As %String [ SqlColumnNumber = 2, SqlFieldName = Score_Ward ];

/// 检查者
Property CheckUser As %String [ SqlColumnNumber = 3, SqlFieldName = Check_User ];

/// 检查月份
Property CheckMonth As %Date [ SqlColumnNumber = 4, SqlFieldName = Check_Month ];

/// 得分
Property CheckScore As %String [ SqlColumnNumber = 5, SqlFieldName = Check_Score ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 6, SqlFieldName = Create_Date ];

/// 状态 【S:提交 N:未提交 B:驳回】
Property Status As %String [ SqlColumnNumber = 7, SqlFieldName = Status ];

/// 质控类型id
Property CheckDR As %String [ SqlColumnNumber = 8, SqlFieldName = Check_DR ];

/// 评分类型 1：按比例。2：按分值；空为按比例
Property CheckScoreType As %String [ SqlColumnNumber = 9, SqlFieldName = Check_ScoreType ];

/// 质控来源1：标准；2：重组
Property CheckType As %Integer [ SqlColumnNumber = 10, SqlFieldName = Check_Type ];

/// 检查任务ID【DHCNMG.CHK.MgNurTaskRelease】
Property TaskID As %String [ SqlColumnNumber = 11, SqlFieldName = Task_ID ];

/// 提交日期
Property SubmitDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Submit_Date ];

/// 备注
Property Remark As %String(MAXLEN = 1000) [ SqlColumnNumber = 13, SqlFieldName = Remark ];

/// 是否重点关注
Property IfFocus As %Boolean [ SqlColumnNumber = 14, SqlFieldName = If_Focus ];

Index stat On (CheckType, CheckDR, ScoreWard, CheckMonth);

Index Date On (ScoreWard, CheckMonth);

Index Qual On (CheckDR, ScoreWard, CheckMonth);

Index task On (TaskID, CheckType, CheckDR, ScoreWard);

Index stic On (CheckDR, ScoreWard);

Storage Default
{
<Data name="MgCheckRoomDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ScoreWard</Value>
</Value>
<Value name="3">
<Value>CheckUser</Value>
</Value>
<Value name="4">
<Value>CheckMonth</Value>
</Value>
<Value name="5">
<Value>CheckScore</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>CheckType</Value>
</Value>
<Value name="9">
<Value>CheckDR</Value>
</Value>
<Value name="10">
<Value>CheckScoreType</Value>
</Value>
<Value name="11">
<Value>TaskID</Value>
</Value>
<Value name="12">
<Value>SubmitDate</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
<Value name="14">
<Value>IfFocus</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgCheckRoomD</DataLocation>
<DefaultData>MgCheckRoomDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgCheckRoomD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgCheckRoomI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgCheckRoomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
