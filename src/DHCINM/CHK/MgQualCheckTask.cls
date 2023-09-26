/// Descriptions:质控查房、夜查房任务
/// Date:2020-06-02
/// Creator:wangpf
Class DHCINM.CHK.MgQualCheckTask Extends %Persistent
{

/// 检查任务
Property TaskItem As list Of %String [ SqlColumnNumber = 2, SqlFieldName = Task_Item ];

/// 检查类型
Property TaskType As CT.DHCINM.Set.MgSysParamSub [ SqlColumnNumber = 3, SqlFieldName = Task_Type ];

/// 检查人
Property TaskCheckPerson As list Of %String [ SqlColumnNumber = 4, SqlFieldName = Task_CheckPerson ];

/// 夜查房检查人分组名称:CF.DHCINM.CHK.CheckGroup.GroupCategory 质控查房检查组Id:DHCINM.CHK.MgQualGroup
Property TaskPersonGroup As %String [ SqlColumnNumber = 5, SqlFieldName = Task_PersonGroup ];

/// 检查病区
Property TaskCheckWard As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Task_CheckWards ];

/// 检查病区分组名称 CF.DHCINM.CHK.CheckWard.WardGroup
Property TaskWardGroup As %String [ SqlColumnNumber = 7, SqlFieldName = Task_WardGroup ];

/// 检查任务级别 W：病区 L：科室 H：护理部
Property TaskLevel As %String [ SqlColumnNumber = 8, SqlFieldName = Task_Level ];

/// 开始日期 夜查房(日历模式)开始日期=结束日期
Property TaskStDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Task_StDate ];

/// 结束日期
Property TaskEndDate As %Date [ SqlColumnNumber = 10, SqlFieldName = Task_EndDate ];

/// 状态 N：保存 Y：发布
Property TaskStatus As %String [ SqlColumnNumber = 11, SqlFieldName = Task_Status ];

/// 创建人
Property CreateUser As %String [ SqlColumnNumber = 12, SqlFieldName = Create_User ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 13, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 14, SqlFieldName = Create_Time ];

/// 是否随机检查 Y:是 空或N:否
Property TaskIsRandom As %String [ SqlColumnNumber = 15, SqlFieldName = Task_IsRandom ];

/// 质控种类
Property TaskQualClass As %String [ SqlColumnNumber = 16, SqlFieldName = Task_QualClass ];

/// 备注
Property TaskRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 17, SqlFieldName = Task_Remark ];

Index Type On (TaskIsRandom, TaskType);

Index Date On (TaskIsRandom, TaskStDate);

Index TypeDate On (TaskIsRandom, TaskType, TaskStDate);

Index Status On (TaskIsRandom, TaskStatus, TaskType);

Index Random On TaskIsRandom;

Storage Default
{
<Data name="MgQualCheckTaskDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TaskItem</Value>
</Value>
<Value name="3">
<Value>TaskType</Value>
</Value>
<Value name="4">
<Value>TaskCheckPerson</Value>
</Value>
<Value name="5">
<Value>TaskPersonGroup</Value>
</Value>
<Value name="6">
<Value>TaskCheckWard</Value>
</Value>
<Value name="7">
<Value>TaskWardGroup</Value>
</Value>
<Value name="8">
<Value>TaskLevel</Value>
</Value>
<Value name="9">
<Value>TaskStDate</Value>
</Value>
<Value name="10">
<Value>TaskEndDate</Value>
</Value>
<Value name="11">
<Value>TaskStatus</Value>
</Value>
<Value name="12">
<Value>CreateUser</Value>
</Value>
<Value name="13">
<Value>CreateDate</Value>
</Value>
<Value name="14">
<Value>CreateTime</Value>
</Value>
<Value name="15">
<Value>TaskIsRandom</Value>
</Value>
<Value name="16">
<Value>TaskQualClass</Value>
</Value>
<Value name="17">
<Value>TaskRemark</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgQualCheckTaskD</DataLocation>
<DefaultData>MgQualCheckTaskDefaultData</DefaultData>
<IdLocation>^DHCINM.CHK.MgQualCheckTaskD</IdLocation>
<IndexLocation>^DHCINM.CHK.MgQualCheckTaskI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgQualCheckTaskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
