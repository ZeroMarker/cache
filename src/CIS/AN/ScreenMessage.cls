/// 大屏消息
Class CIS.AN.ScreenMessage Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ScreenMessage ]
{

/// 消息发布者
Property Sender As %String [ SqlColumnNumber = 2 ];

/// 连接大屏电脑IP地址
Property ClientIP As %String [ SqlColumnNumber = 3 ];

/// 消息内容
Property Message As %String(MAXLEN = 500) [ SqlColumnNumber = 4 ];

/// 消息在大屏上显示多长时间(分钟)
Property Duration As %Integer [ SqlColumnNumber = 5 ];

/// 消息发布日期
Property ReleaseDate As %Date [ SqlColumnNumber = 6 ];

/// 消息发布时间
Property ReleaseTime As %Time [ SqlColumnNumber = 7 ];

/// 消息创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8 ];

/// 消息创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9 ];

/// 消息创建用户
Property CreateUser As %String [ SqlColumnNumber = 10 ];

/// 消息更新用户
Property UpdateUser As %String [ SqlColumnNumber = 11 ];

/// 消息更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 12 ];

/// 消息更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 13 ];

/// 接收消息的安全组ID
Property RecvGroup As %String [ SqlColumnNumber = 14 ];

/// 接收消息的用户ID
Property RecvUser As %String [ SqlColumnNumber = 15 ];

/// 接收消息的科室ID
Property RecvDept As %String [ SqlColumnNumber = 16 ];

/// 消息关联的手术
Property OperSchedule As CIS.AN.OperSchedule [ SqlColumnNumber = 17 ];

/// 消息播放次数
Property PlayTimes As %Integer [ SqlColumnNumber = 18 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 发布日期索引
Index IRelDate On ReleaseDate;

Storage Default
{
<Data name="ScreenMessageDefaultData">
<Value name="1">
<Value>Sender</Value>
</Value>
<Value name="2">
<Value>ClientIP</Value>
</Value>
<Value name="3">
<Value>Message</Value>
</Value>
<Value name="4">
<Value>Duration</Value>
</Value>
<Value name="5">
<Value>ReleaseDate</Value>
</Value>
<Value name="6">
<Value>ReleaseTime</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>CreateUser</Value>
</Value>
<Value name="10">
<Value>UpdateUser</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>UpdateTime</Value>
</Value>
<Value name="13">
<Value>RecvGroup</Value>
</Value>
<Value name="14">
<Value>RecvUser</Value>
</Value>
<Value name="15">
<Value>RecvDept</Value>
</Value>
<Value name="16">
<Value>OperSchedule</Value>
</Value>
<Value name="17">
<Value>PlayTimes</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ScreenMessageD</DataLocation>
<DefaultData>ScreenMessageDefaultData</DefaultData>
<IdLocation>^CIS.AN.ScreenMessageD</IdLocation>
<IndexLocation>^CIS.AN.ScreenMessageI</IndexLocation>
<StreamLocation>^CIS.AN.ScreenMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
