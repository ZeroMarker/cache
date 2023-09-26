/// Creator:guozj
/// Descriptions:护士长夜查房表
/// Date:2018-05-07
/// 
Class DHCNMG.CHK.MgNurNightCheck Extends %Persistent
{

Relationship ChildSub As DHCNMG.CHK.MgNurNightCheckSub [ Cardinality = children, Inverse = Parref ];

/// 排班记录ID
Property TaskID As DHCNMG.CHK.MgNurHeadSchdule [ SqlColumnNumber = 2, SqlFieldName = Task_ID ];

/// 任务日期 对应排班表日期
Property TaskDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Task_Date ];

/// 任务描述【质控配置父表ID】
Property TaskQualID As %Integer [ SqlColumnNumber = 4, SqlFieldName = TaskQualID ];

/// 检查病区
Property TaskWard As %String [ SqlColumnNumber = 5, SqlFieldName = Task_Ward ];

/// 检查日期
Property TaskChkDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Task_ChkDate ];

/// 检查人
Property TaskUser As %String [ SqlColumnNumber = 7, SqlFieldName = Task_User ];

/// 护士长签名
Property TaskHeadNur As %String [ SqlColumnNumber = 8, SqlFieldName = Task_HeadNur ];

/// 是否重点关注
Property IfFocus As %Boolean [ SqlColumnNumber = 9, SqlFieldName = If_Focus ];

Index Ward On (TaskID, TaskQualID, TaskWard);

Index TaskID On TaskID;

Index date On (TaskDate, TaskID);

Storage Default
{
<Data name="MgNurNightCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TaskDate</Value>
</Value>
<Value name="3">
<Value>TaskDesc</Value>
</Value>
<Value name="4">
<Value>TaskID</Value>
</Value>
<Value name="5">
<Value>TaskWard</Value>
</Value>
<Value name="6">
<Value>TaskChkDate</Value>
</Value>
<Value name="7">
<Value>TaskUser</Value>
</Value>
<Value name="8">
<Value>TaskQualID</Value>
</Value>
<Value name="9">
<Value>TaskHeadNur</Value>
</Value>
<Value name="10">
<Value>IfFocus</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgNurNightCheckD</DataLocation>
<DefaultData>MgNurNightCheckDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgNurNightCheckD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgNurNightCheckI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgNurNightCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
