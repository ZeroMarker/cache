Class CIS.AN.SRV.MessageService Extends %RegisteredObject
{

ClassMethod SendPhoneMessage(messageId As %String, userId As %String) As %String
{
	set phoneMessage=##class(CIS.AN.PhoneMessage).%OpenId(messageId)
	set phoneNumber=phoneMessage.PhoneNumber
	//quit:(phoneNumber="") "E^患者手机号为空"
	quit:(phoneMessage.Flag'="N") "E^不能发送已经作废的短信"
	set content=phoneMessage.Content
	set EpisodeID=phoneMessage.OperSchedule.EpisodeID
	//s soapAA=##class(web.DHCENS.BLL.SOAPMessage.WebMessageSoap).%New()
	//s soapAA.Timeout=5
	//s stream=soapAA.SendMessage(4,phoneNumber,content,EpisodeID)
	set phoneMessage.SendUser=userId
	set phoneMessage.SendDate=+$h
	set phoneMessage.SendTime=$p($h,",",2)
	set phoneMessage.SendResult="发送成功"
	set phoneMessage.Status="SS"
	//set:(+stream'=1) phoneMessage.Status="FS"
	//set phoneMessage.Status="FS"
	set sc=phoneMessage.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

}
