Class web.DHCMDTWebSocketServercls Extends %CSP.WebSocket
{

Method OnPreServer() As %Status
{
	Set ..SharedConnection = 1
	
	Set lgHospID=$g(%session.Data("LOGON.HOSPID"))
	Set lgLocID=$g(%session.Data("LOGON.CTLOCID"))
	Set lgGroupID=$g(%session.Data("LOGON.GROUPID"))
	Set lgUserID=$g(%session.Data("LOGON.USERID"))
	Set thisWsId=..WebSocketID
	;断开上次的链接
	If ($d(^TMPData("DHCNEWPRO","web.DHCMDT","WebSocketID",lgUserID))){
		Set wsId=^TMPData("DHCNEWPRO","web.DHCMDT","WebSocketID",lgUserID)
		;If (wsId'=thisWsId){
		;关闭上次记录的id会出现问题这里暂时不做关闭
		If (wsId'=thisWsId){
			Set ^qqa("op")=wsId_"!!"_thisWsId
			Set ws=##class(web.DHCMDTWebSocketServer).%New()
			Set %status = ws.OpenServer(wsId)
			Set %status=ws.EndServer()
		}
	}
	;记录新的链接
	Set ^TMPData("DHCNEWPRO","web.DHCMDT","WebSocketID",lgUserID)=thisWsId
	Quit $$$OK
}

Method Server() As %Status
{
	Quit $$$OK
}

Method OnPostServer() As %Status
{
	Quit $$$OK
}

/// w ##class(web.DHCMDTWebSocketServer).Send("12320","11843")
ClassMethod Send(userId, text)
{
	
	Set errMsg=0
	Set ws=##class(web.DHCMDTWebSocketServer).%New()
	Set userRowId=0
	For {
		Set userRowId=$o(^TMPData("DHCNEWPRO","web.DHCMDT","WebSocketID",userRowId))
		Quit:userRowId=""
		Continue:(userId'="")&&(userId'=userRowId)
		Set socketID=^TMPData("DHCNEWPRO","web.DHCMDT","WebSocketID",userRowId)
		Set %status=ws.OpenServer(socketID)
		If (%status'=1){
			k ^TMPData("DHCNEWPRO","web.DHCMDT","WebSocketID",userRowId)
			Continue
		}
	
		If (ws.SessionId=""){
			k ^TMPData("DHCNEWPRO","web.DHCMDT","WebSocketID",userRowId)
			Continue
		}
		Set %status=ws.Write(text)
		If (%status'=1){
			Set errMsg="write错误,信息"_%status
		}
	} 
	q errMsg
}

/// w ##class(web.DHCMDTWebSocketServer).ClosedOne("12176")
ClassMethod ClosedOne(UserId)
{
	Quit:'$d(^TMPData("DHCNEWPRO","web.DHCMDT","WebSocketID",UserId)) 0
	Set socketId=^TMPData("DHCNEWPRO","web.DHCMDT","WebSocketID",UserId)
	b ;err1
	;Kill ^TMPData("DHCNEWPRO","web.DHCMDT","WebSocketID",UserId)
	Set ws=##class(web.DHCMDTWebSocketServer).%New()
	b ;333
	Do ws.OpenServer(socketId)
	Do ws.clos()
	q 0
}

/// w ##class(web.DHCMDTWebSocketServer).faceAdoptCall(^qqa("ParamStr"))
ClassMethod faceAdoptCall(jsoText)
{
	s ^qqa("faceAdoptCall")="ok"
	if ($IsObject(jsoText)){
		s jsoText=jsoText.%ToJSON()	
	}
	s ^qqa("faceAdoptCall")=jsoText
	Set ret=##class(web.DHCMDTWebSocketServer).Send("",jsoText)
	Quit ret
}

/// Descript:结束ws
/// w ##class(web.DHCMDTWebSocketServer).%New().ClsoeWsServer("wotcVIVsAeyqS+37hSQQaQ==")
Method ClsoeWsServer(socketID)
{
	Set ws=##class(web.DHCMDTWebSocketServer).%New()
	Set %status = ws.OpenServer(socketID)
	Set %status=ws.EndServer()
	Do ws.%Close()
	q ""
}

/// w ##class(web.DHCMDTWebSocketServer).Test("LLXwG8LckOlLIG827IyiBA==")
ClassMethod Test(socketID)
{
	Set ws=##class(web.DHCMDTWebSocketServer).%New()
	Set %status = ws.OpenServer(socketID)
	Set %status=ws.EndServer()
	q ""
}

}
