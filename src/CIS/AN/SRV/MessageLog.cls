Class CIS.AN.SRV.MessageLog Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = MessageLog ]
{

/// 接口消息
Property InterfaceMessage As CIS.AN.SRV.InterfaceMessage [ Required, SqlColumnNumber = 2 ];

/// 消息方法
Property MessageMethod As CIS.AN.SRV.MessageMethod [ Required, SqlColumnNumber = 3 ];

/// 发送用户
Property SendUser As %String [ SqlColumnNumber = 4 ];

/// 发送日期
Property SendDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5 ];

/// 发送时间
Property SendTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6 ];

/// 消息原文
Property OriginalText As %String(MAXLEN = 30000) [ SqlColumnNumber = 7 ];

/// 消息返回值
Property ReturnValue As %String(MAXLEN = 30000) [ SqlColumnNumber = 8 ];

Index IMessageMethod On MessageMethod;

Index IInterfaceMessage On InterfaceMessage;

Index ISendDate On SendDate;

Index IDateMethod On (SendDate, MessageMethod);

Index IDateMessage On (SendDate, InterfaceMessage);

ClassMethod NewLog(interfaceMessageId As %String, messageMethodId As %String, sentUser, originalText As %String, returnValue As %String) As %String
{
  set messageLog=##class(CIS.AN.SRV.MessageLog).%New()
  set messageLog.InterfaceMessage=##class(CIS.AN.SRV.InterfaceMessage).%OpenId(interfaceMessageId)
  set messageLog.MessageMethod=##class(CIS.AN.SRV.MessageMethod).%OpenId(messageMethodId)
  set messageLog.SendUser=sentUser
  set messageLog.OriginalText=originalText
  set messageLog.ReturnValue=returnValue
  set sc=messageLog.%Save()
  quit:($$$ISERR(sc)) "E^保存消息日志失败"
  quit "S^"
}

Storage Default
{
<Data name="MessageLogDefaultData">
<Value name="1">
<Value>InterfaceMessage</Value>
</Value>
<Value name="2">
<Value>MessageMethod</Value>
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
<Value>OriginalText</Value>
</Value>
<Value name="7">
<Value>ReturnValue</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SRV.MessageLogD</DataLocation>
<DefaultData>MessageLogDefaultData</DefaultData>
<IdLocation>^CIS.AN.SRV.MessageLogD</IdLocation>
<IndexLocation>^CIS.AN.SRV.MessageLogI</IndexLocation>
<StreamLocation>^CIS.AN.SRV.MessageLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
