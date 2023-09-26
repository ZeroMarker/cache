Class web.DHCPRESCWebSocketServer Extends %CSP.WebSocket
{

Method OnPreServer() As %Status
{
	Set ..SharedConnection = 1
	
	Set userType=$Get(%request.Data("userType",1),"")
	Set lgHospID=$g(%session.Data("LOGON.HOSPID"))
	Set lgLocID=$g(%session.Data("LOGON.CTLOCID"))
	Set lgGroupID=$g(%session.Data("LOGON.GROUPID"))
	Set lgUserID=$g(%session.Data("LOGON.USERID"))
	Set thisWsId=..WebSocketID
	;断开上次的链接
	If ($d(^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",userType,lgUserID))){
		Set wsId=^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",userType,lgUserID)
		;If (wsId'=thisWsId){
		;关闭上次记录的id会出现问题这里暂时不做关闭
		If (wsId'=thisWsId){
			Set ^qqa("op")=wsId_"!!"_thisWsId
			Set ws=##class(web.DHCPRESCWebSocketServer).%New()
			Set %status = ws.OpenServer(wsId)
			Set %status=ws.EndServer()
		}
	}
	;记录新的链接
	Set ^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",userType,lgUserID)=thisWsId
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

/// w ##class(web.DHCPRESCWebSocketServer).Send("Doctor","11843","0^0")
ClassMethod Send(userType, userId, text)
{
	
	Set errMsg=0
	Set ws=##class(web.DHCPRESCWebSocketServer).%New()
	Set userRowId=0
	For {
		Set userRowId=$o(^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",userType,userRowId))
		Quit:userRowId=""
		Continue:(userId'="")&&(userId'=userRowId)
		Set socketID=^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",userType,userRowId)
		Set %status=ws.OpenServer(socketID)
		If (%status'=1){
			k ^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",userType,userRowId)
			Continue
		}
	
		If (ws.SessionId=""){
			k ^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",userType,userRowId)
			Continue
		}
		Set %status=ws.Write(text)
		If (%status'=1){
			Set errMsg="write错误,信息"_%status
		}
	} 
	q errMsg
}

Method OnPreServerBak() As %Status
{
	Set ..SharedConnection = 1
	
	Set userType=$Get(%request.Data("userType",1),"")
	Set conType=$Get(%request.Data("conType",1),"") ;UnRead/Message
	Set lgHospID=$g(%session.Data("LOGON.HOSPID"))
	Set lgLocID=$g(%session.Data("LOGON.CTLOCID"))
	Set lgGroupID=$g(%session.Data("LOGON.GROUPID"))
	Set lgUserID=$g(%session.Data("LOGON.USERID"))
	Set thisWsId=..WebSocketID
	;断开上次的链接
	If ($d(^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",conType,userType,lgUserID))){
		Set wsId=^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",conType,userType,lgUserID)
		;If (wsId'=thisWsId){
		;关闭上次记录的id会出现问题这里暂时不做关闭
		If (wsId'=thisWsId){
			Set ^qqa("op")=wsId_"!!"_thisWsId
			Set ws=##class(web.DHCPRESCWebSocketServer).%New()
			Set %status = ws.OpenServer(wsId)
			Set %status=ws.EndServer()
		}
	}
	;记录新的链接
	Set ^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",conType,userType,lgUserID)=thisWsId
	Quit $$$OK
}

/// w ##class(web.DHCPRESCWebSocketServer).Send("UnRead","Doctor","11843","0^0")
ClassMethod SendBak(conType, userType, userId, text)
{
	
	Set errMsg=0
	Set ws=##class(web.DHCPRESCWebSocketServer).%New()
	Set userRowId=0
	For {
		Set userRowId=$o(^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",conType,userType,userRowId))
		Quit:userRowId=""
		Continue:(userId'="")&&(userId'=userRowId)
		Set socketID=^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",conType,userType,userRowId)
		Set %status=ws.OpenServer(socketID)
		If (%status'=1){
			k ^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",conType,userType,userRowId)
			Continue
		}
	
		If (ws.SessionId=""){
			k ^TMPData("DHCNEWPRO","web.DHCPRESC","WebSocketID",conType,userType,userRowId)
			Continue
		}
		Set %status=ws.Write(text)
		If (%status'=1){
			Set errMsg="write错误,信息"_%status
		}
	} 
	q errMsg
}

/// Descript:结束ws
/// w ##class(web.DHCPRESCWebSocketServer).%New().ClsoeWsServer("wotcVIVsAeyqS+37hSQQaQ==")
Method ClsoeWsServer(socketID)
{
	Set ws=##class(web.DHCPRESCWebSocketServer).%New()
	Set %status = ws.OpenServer(socketID)
	Set %status=ws.EndServer()
	Do ws.%Close()
	q ""
}

/// w ##class(web.DHCPRESCWebSocketServer).Test("LLXwG8LckOlLIG827IyiBA==")
ClassMethod Test(socketID)
{
	Set ws=##class(web.DHCPRESCWebSocketServer).%New()
	Set %status = ws.OpenServer(socketID)
	Set %status=ws.EndServer()
	q ""
}

}
