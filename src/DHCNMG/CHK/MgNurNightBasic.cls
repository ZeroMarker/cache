/// Creator:lulin
/// Descriptions:护士长夜查房基本信息表
/// Date:2018-09-09
/// 
Class DHCNMG.CHK.MgNurNightBasic Extends %Persistent
{

/// 排班记录ID
Property TaskID As DHCNMG.CHK.MgNurHeadSchdule [ SqlColumnNumber = 2, SqlFieldName = Task_ID ];

/// 任务日期 对应排班表日期
Property TaskDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Task_Date ];

/// 检查病区
Property TaskWard As %String [ SqlColumnNumber = 4, SqlFieldName = Task_Ward ];

/// 填写日期【修改日期】
Property TaskChkDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Task_ChkDate ];

/// 病人总数
Property TaskPat As %String [ SqlColumnNumber = 6, SqlFieldName = Task_Pat ];

/// 重病人数
Property TastSerPat As %String [ SqlColumnNumber = 7, SqlFieldName = Tast_SerPat ];

/// 抢救人数急诊手术
Property TaskResPat As %String [ SqlColumnNumber = 8, SqlFieldName = Task_ResPat ];

/// 值班护士(大夜)
Property TaskNightNur As %String [ SqlColumnNumber = 9, SqlFieldName = Task_NightNur ];

Property TaskSort As %Integer [ SqlColumnNumber = 10, SqlFieldName = Task_Sort ];

Index TaskID On TaskID;

Index Ward On (TaskID, TaskWard);

Storage Default
{
<Data name="MgNurNightBasicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TaskID</Value>
</Value>
<Value name="3">
<Value>TaskDate</Value>
</Value>
<Value name="4">
<Value>TaskWard</Value>
</Value>
<Value name="5">
<Value>TaskChkDate</Value>
</Value>
<Value name="6">
<Value>TaskPat</Value>
</Value>
<Value name="7">
<Value>TastSerPat</Value>
</Value>
<Value name="8">
<Value>TaskResPat</Value>
</Value>
<Value name="9">
<Value>TaskNightNur</Value>
</Value>
<Value name="10">
<Value>TaskSort</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgNurNightBasicD</DataLocation>
<DefaultData>MgNurNightBasicDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgNurNightBasicD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgNurNightBasicI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgNurNightBasicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
