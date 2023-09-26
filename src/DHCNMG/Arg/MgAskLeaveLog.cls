Class DHCNMG.Arg.MgAskLeaveLog Extends %Persistent
{

/// 请假记录 
Property AskLeaveDR As %String [ SqlColumnNumber = 2, SqlFieldName = AskLeave_DR ];

/// 护士
Property LeavePerDR As %String [ SqlColumnNumber = 3, SqlFieldName = Leave_PerDR ];

/// 请假开始日期
Property LeaveStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Leave_StDate ];

/// 修改前记录
Property LogBefor As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = Log_Befor ];

/// 修改后记录
Property LogAfter As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = Log_After ];

/// 修改记录
Property LogRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = Log_Remark ];

/// 操作人
Property LogCrt As %String [ SqlColumnNumber = 8, SqlFieldName = Log_Crt ];

/// 操作日期
Property LogCrtDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Log_CrtDate ];

/// 操作时间
Property LogCrtTime As %Time [ SqlColumnNumber = 10, SqlFieldName = Log_CrtItem ];

Index Leave On AskLeaveDR;

Storage Default
{
<Data name="MgAskLeaveLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AskLeaveDR</Value>
</Value>
<Value name="3">
<Value>LeavePerDR</Value>
</Value>
<Value name="4">
<Value>LeaveStDate</Value>
</Value>
<Value name="5">
<Value>LogBefor</Value>
</Value>
<Value name="6">
<Value>LogAfter</Value>
</Value>
<Value name="7">
<Value>LogRemark</Value>
</Value>
<Value name="8">
<Value>LogCrt</Value>
</Value>
<Value name="9">
<Value>LogCrtDate</Value>
</Value>
<Value name="10">
<Value>LogCrtTime</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgAskLeaveLogD</DataLocation>
<DefaultData>MgAskLeaveLogDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgAskLeaveLogD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgAskLeaveLogI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgAskLeaveLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
