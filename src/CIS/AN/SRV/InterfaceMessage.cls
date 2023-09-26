Class CIS.AN.SRV.InterfaceMessage Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = InterfaceMessage ]
{

/// 业务ID(手术申请ID，重症监护ID，血透登记ID)
Property BusinessID As %String [ Required, SqlColumnNumber = 2 ];

/// 创建用户
Property CreateUser As %String [ Required, SqlColumnNumber = 3 ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 4 ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 5 ];

/// 接口方法
Property MethodCode As %String [ Required, SqlColumnNumber = 6 ];

/// 最后发送用户
Property SendUser As %String [ SqlColumnNumber = 7 ];

/// 最后发送日期
Property SendDate As %Date [ SqlColumnNumber = 8 ];

/// 最后发送时间
Property SendTime As %Time [ SqlColumnNumber = 9 ];

/// 消息发送状态
Property SendFlag As %String(DISPLAYLIST = ",新建,已发送,已撤销", VALUELIST = ",N,S,R") [ SqlColumnNumber = 10 ];

/// 参数
Property Params As %String(MAXLEN = 200) [ SqlColumnNumber = 11 ];

Index IMethodCode On MethodCode;

Index ISendFlag On SendFlag;

/// Description
Trigger SendEvent [ Event = INSERT, Foreach = row/object, Time = AFTER ]
{
  // do something
  set messageId={RowId}
  w !,"Trigger Send Event, id:"_messageId
  do ##class(CIS.AN.SRV.InterfaceMessage).Invoke(messageId,1)
}

ClassMethod NewMessage(businessID As %String, methodCode As %String, createUser As %String, params As %String = "") As %String
{
  set interfaceMessage=##class(CIS.AN.SRV.InterfaceMessage).%New()
  set interfaceMessage.BusinessID=businessID
  set interfaceMessage.MethodCode=methodCode
  set interfaceMessage.CreateUser=createUser
  set interfaceMessage.SendFlag="N"
  set interfaceMessage.Params=params
  set sc=interfaceMessage.%Save()
  quit:($$$ISERR(sc)) "E^创建接口消息错误"
  quit "S^"
}

ClassMethod UpdateSentFlag(messageId As %String, sendUser As %String) As %String
{
  set curMessage=##class(CIS.AN.SRV.InterfaceMessage).%OpenId(messageId)
  set curMessage.SendUser=sendUser
  set curMessage.SendDate=+$h
  set curMessage.SendTime=$p($h,",",2)
  set curMessage.SendFlag="S"
  set sc=curMessage.%Save()
  quit:($SYSTEM.Status.IsError(sc)) "E^"_$SYSTEM.Status.GetErrorText(sc)
  quit "S^"
}

ClassMethod InvokeAll() As %String
{
  &sql(declare messageCursor cursor for select RowId,CreateUser into :msgId,:createUser
       from CIS_AN_SRV.InterfaceMessage
       where SendFlag='N')
  &sql(open messageCursor)
  for
  {
    &sql(fetch messageCursor)
    quit:(SQLCODE'=0)
    do ..Invoke(msgId)
    do ..UpdateSentFlag(msgId,createUser)
  }
  &sql(close messageCursor)
  quit "S^"
}

ClassMethod Invoke(curMessageId As %String, single As %Boolean = 0) As %String
{
  set curMessage=##class(CIS.AN.SRV.InterfaceMessage).%OpenId(curMessageId)
  set messageMethodList=##class(CIS.AN.SRV.MessageMethod).GetByCode(curMessage.MethodCode)
  set params=curMessage.Params
  for i=1:1:messageMethodList.Size
  {
    set messageMethod=messageMethodList.GetAt(i)
    set returnValue= $CLASSMETHOD(messageMethod.ClassName,messageMethod.MethodName,curMessage.BusinessID,params)
    set originalText=$p(returnValue,$c(0),1)
    set resultValue=$p(returnValue,$c(0),2)
    do ##class(CIS.AN.SRV.MessageLog).NewLog(curMessageId,messageMethod.%Id(),curMessage.CreateUser,originalText,resultValue)
  }

  do:(single) ..UpdateSentFlag(curMessageId,curMessage.CreateUser)
}

Storage Default
{
<Data name="InterfaceMessageDefaultData">
<Value name="1">
<Value>BusinessID</Value>
</Value>
<Value name="2">
<Value>CreateUser</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>MethodCode</Value>
</Value>
<Value name="6">
<Value>SendUser</Value>
</Value>
<Value name="7">
<Value>SendDate</Value>
</Value>
<Value name="8">
<Value>SendTime</Value>
</Value>
<Value name="9">
<Value>SendFlag</Value>
</Value>
<Value name="10">
<Value>Params</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SRV.InterfaceMessageD</DataLocation>
<DefaultData>InterfaceMessageDefaultData</DefaultData>
<IdLocation>^CIS.AN.SRV.InterfaceMessageD</IdLocation>
<IndexLocation>^CIS.AN.SRV.InterfaceMessageI</IndexLocation>
<StreamLocation>^CIS.AN.SRV.InterfaceMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
