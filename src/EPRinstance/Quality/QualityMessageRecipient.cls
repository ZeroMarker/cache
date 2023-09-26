Class EPRinstance.Quality.QualityMessageRecipient Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEpisodeID On EpisodeID;

//DO ##class(EPRinstance.Quality.QualityMessageRecipient).%BuildIndices()

Index IdxMessageDR On MessageDR;

/// 反馈消息的患者就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 指向QualityMessage
Property MessageDR As %String(TRUNCATE = 1);

/// 读消息日期
Property ReadDate As %Date;

/// 读消息时间
Property ReadTime As %Time;

/// 读取消息用户SS_User.SSUSR_RowID
Property ReadUserDR As %String(TRUNCATE = 1);

/// d ##class(EPRinstance.Quality.QualityMessageRecipient).UpdateOldData()
ClassMethod UpdateOldData() As %String
{
	s rowID = ""
	for {
		s rowID=$o(^DHCEPRQ.QualityMsgRecD(rowID))
		q:(rowID = "")
		
		s msgRObj = ##class(EPRinstance.Quality.QualityMessageRecipient).%OpenId(rowID)

		s MessageDr = msgRObj.MessageDR
		s EpisodeID = msgRObj.EpisodeID
		s ReceiveUserID = msgRObj.ReadUserDR
		s ReadDate = msgRObj.ReadDate
		s ReadTime = msgRObj.ReadTime	

		s msgObj = ##class(EPRinstance.Quality.QualityMessage).%OpenId(MessageDr)	
		s CreateUser = msgObj.CreateUserDR
		s CreateDate = msgObj.CreateDate
		s CreateTime = msgObj.CreateTime
		s Message = msgObj.MessageBody
		
		s ret = ##class(EPRservice.BLL.BLEPRMessage).UpdateOldQualityMessage(CreateUser,ReceiveUserID,CreateDate,CreateTime,ReadDate,ReadTime,"质控消息",Message,"QUALITY",EpisodeID)
		w !,ret
	}
}

Storage Default
{
<Data name="QualityMessageRecipientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>MessageDR</Value>
</Value>
<Value name="4">
<Value>ReadDate</Value>
</Value>
<Value name="5">
<Value>ReadTime</Value>
</Value>
<Value name="6">
<Value>ReadUserDR</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.QualityMsgRecD</DataLocation>
<DefaultData>QualityMessageRecipientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRQ.QualityMsgRecD</IdLocation>
<IndexLocation>^DHCEPRQ.QualityMsgRecI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualityMsgRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
