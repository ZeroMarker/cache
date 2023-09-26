/// 手机短信表
Class CIS.AN.PhoneMessage Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PhoneMessage ]
{

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 短信内容
Property Content As %String(MAXLEN = 1000) [ Required, SqlColumnNumber = 3 ];

/// 短信发送用户
Property SendUser As %String [ SqlColumnNumber = 4 ];

/// 短信发送日期
Property SendDate As %Date [ SqlColumnNumber = 5 ];

/// 短信发送时间
Property SendTime As %Time [ SqlColumnNumber = 6 ];

/// 短信接口返回结果
Property SendResult As %String(MAXLEN = 1000) [ SqlColumnNumber = 7 ];

/// 短信发送状态
Property Status As %String(DISPLAYLIST = ",未发送,已发送,发送失败", VALUELIST = ",US,SS,FS") [ SqlColumnNumber = 8 ];

/// 短信创建用户
Property CreateUser As %String [ SqlColumnNumber = 9 ];

/// 短信创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10 ];

/// 短信创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11 ];

/// 短信正常、作废标志
Property Flag As %String(DISPLAYLIST = ",正常,作废", VALUELIST = ",N,C") [ SqlColumnNumber = 12 ];

/// 短信作废用户
Property CancelUser As %String [ SqlColumnNumber = 13 ];

/// 短信作废日期
Property CancelDate As %Date [ SqlColumnNumber = 14 ];

/// 短信作废时间
Property CancelTime As %Time [ SqlColumnNumber = 15 ];

/// 业务代码(手麻系统有多项业务需要发送短信，用业务代码区分，业务代码在数据字典中维护)
Property BusinessCode As %String [ SqlColumnNumber = 16 ];

/// 手机号码
Property PhoneNumber As %String [ SqlColumnNumber = 17 ];

Index IOPS On OperSchedule;

Index IBusinessCode On BusinessCode;

Index ISendDate On SendDate;

Index IFlag On Flag;

Index IStatus On Status;

Index IPhoneNumber On PhoneNumber;

Storage Default
{
<Data name="PhoneMessageDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>Content</Value>
</Value>
<Value name="3">
<Value>SendUser</Value>
</Value>
<Value name="4">
<Value>SendDate</Value>
</Value>
<Value name="5">
<Value>SendTime</Value>
</Value>
<Value name="6">
<Value>SendResult</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>CreateUser</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateTime</Value>
</Value>
<Value name="11">
<Value>Flag</Value>
</Value>
<Value name="12">
<Value>CancelUser</Value>
</Value>
<Value name="13">
<Value>CancelDate</Value>
</Value>
<Value name="14">
<Value>CancelTime</Value>
</Value>
<Value name="15">
<Value>BusinessCode</Value>
</Value>
<Value name="16">
<Value>PhoneNumber</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PhoneMessageD</DataLocation>
<DefaultData>PhoneMessageDefaultData</DefaultData>
<IdLocation>^CIS.AN.PhoneMessageD</IdLocation>
<IndexLocation>^CIS.AN.PhoneMessageI</IndexLocation>
<StreamLocation>^CIS.AN.PhoneMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
