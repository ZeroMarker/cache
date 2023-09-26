/// PACU准入管理
Class CIS.AN.PACUAdmission Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PACUAdmission ]
{

/// 手术
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 请求日期
Property RequestDate As %Date [ Required, SqlColumnNumber = 3 ];

/// 请求时间
Property RequestTime As %Time [ Required, SqlColumnNumber = 4 ];

/// 发送者
Property RequestUser As %String [ Required, SqlColumnNumber = 5 ];

/// 发送者安全组
Property RequestGroup As %String [ Required, SqlColumnNumber = 6 ];

/// 发送者科室
Property RequestDept As %String [ Required, SqlColumnNumber = 7 ];

/// 接收者
Property TargetUser As %String [ SqlColumnNumber = 8 ];

/// 接收者安全组
Property TargetGroup As %String [ SqlColumnNumber = 9 ];

/// 接收者科室
Property TargetDept As %String [ SqlColumnNumber = 10 ];

/// 发送状态
Property Status As %String(DISPLAYLIST = ",未发送,已发送,已阅读,已回复,已确认,完成,撤销", VALUELIST = ",Not,Sent,Read,Responded,Confirmed,Finished,Declined") [ Required, SqlColumnNumber = 11 ];

/// 请求床位
Property RequestBed As CF.AN.Location [ SqlColumnNumber = 12 ];

/// 附带说明
Property Note As %String(MAXLEN = 200) [ SqlColumnNumber = 13 ];

/// 阅读日期时间
Property ReadDT As %TimeStamp [ SqlColumnNumber = 14 ];

/// 阅读人
Property Reader As %String [ SqlColumnNumber = 15 ];

/// 回复日期
Property RespondDate As %Date [ SqlColumnNumber = 16 ];

/// 回复时间
Property RespondTime As %Time [ SqlColumnNumber = 17 ];

/// 回复人
Property RespondUser As %Date [ SqlColumnNumber = 18 ];

/// 可用床位
Property AvailableLocation As CF.AN.Location [ SqlColumnNumber = 19 ];

/// 预计可用时间
Property AvailableDT As %TimeStamp [ SqlColumnNumber = 20 ];

/// 确认时间
Property ConfirmDT As %TimeStamp [ SqlColumnNumber = 21 ];

/// 确认用户
Property ConfirmUser As %String [ SqlColumnNumber = 22 ];

Index Date On RequestDate;

Index DateOper On (RequestDate, OperSchedule);

Index Status On Status;

Index DateStatus On (RequestDate, Status);

Index OPS On OperSchedule;

Storage Default
{
<Data name="PACUAdmissionDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>RequestDate</Value>
</Value>
<Value name="3">
<Value>RequestTime</Value>
</Value>
<Value name="4">
<Value>RequestUser</Value>
</Value>
<Value name="5">
<Value>RequestGroup</Value>
</Value>
<Value name="6">
<Value>RequestDept</Value>
</Value>
<Value name="7">
<Value>TargetUser</Value>
</Value>
<Value name="8">
<Value>TargetGroup</Value>
</Value>
<Value name="9">
<Value>TargetDept</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>RequestBed</Value>
</Value>
<Value name="12">
<Value>Note</Value>
</Value>
<Value name="13">
<Value>ReadDT</Value>
</Value>
<Value name="14">
<Value>Reader</Value>
</Value>
<Value name="15">
<Value>RespondDate</Value>
</Value>
<Value name="16">
<Value>RespondTime</Value>
</Value>
<Value name="17">
<Value>RespondUser</Value>
</Value>
<Value name="18">
<Value>AvailableLocation</Value>
</Value>
<Value name="19">
<Value>AvailableDT</Value>
</Value>
<Value name="20">
<Value>ConfirmDT</Value>
</Value>
<Value name="21">
<Value>ConfirmUser</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PACUAdmissionD</DataLocation>
<DefaultData>PACUAdmissionDefaultData</DefaultData>
<IdLocation>^CIS.AN.PACUAdmissionD</IdLocation>
<IndexLocation>^CIS.AN.PACUAdmissionI</IndexLocation>
<StreamLocation>^CIS.AN.PACUAdmissionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
