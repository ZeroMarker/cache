/// Descriptions:护士长夜查房基本信息表
/// Date:2020-06-12
/// Creator:wangpf
Class DHCINM.CHK.MgNurNightBasic Extends %Persistent
{

/// 排班记录ID
Property CheckTask As DHCINM.CHK.MgQualCheckTask [ SqlColumnNumber = 2, SqlFieldName = Check_Task ];

/// 任务日期 对应排班表日期
Property CheckTaskDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Check_TaskDate ];

/// 检查病区
Property CheckWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 4, SqlFieldName = Check_Ward ];

/// 填写日期【修改日期】
Property CheckDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Check_Date ];

/// 病人总数
Property CheckPat As %String [ SqlColumnNumber = 6, SqlFieldName = Check_Pat ];

/// 重病人数
Property CheckSerPat As %String [ SqlColumnNumber = 7, SqlFieldName = Check_SerPat ];

/// 抢救人数急诊手术
Property CheckResPat As %String [ SqlColumnNumber = 8, SqlFieldName = Check_ResPat ];

/// 值班护士(大夜)
Property CheckNightNur As %String [ SqlColumnNumber = 9, SqlFieldName = Check_NightNur ];

Index Ward On (CheckTask, CheckWard);

Storage Default
{
<Data name="MgNurNightBasicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckTask</Value>
</Value>
<Value name="3">
<Value>CheckTaskDate</Value>
</Value>
<Value name="4">
<Value>CheckWard</Value>
</Value>
<Value name="5">
<Value>CheckDate</Value>
</Value>
<Value name="6">
<Value>CheckPat</Value>
</Value>
<Value name="7">
<Value>CheckSerPat</Value>
</Value>
<Value name="8">
<Value>CheckResPat</Value>
</Value>
<Value name="9">
<Value>CheckNightNur</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgNurNightBasicD</DataLocation>
<DefaultData>MgNurNightBasicDefaultData</DefaultData>
<IdLocation>^DHCINM.CHK.MgNurNightBasicD</IdLocation>
<IndexLocation>^DHCINM.CHK.MgNurNightBasicI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgNurNightBasicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
