/// 医生消息沟通内容推送
Class web.DHCPRESCMessageWebSocketServer Extends %CSP.WebSocket
{

Method OnPreServer() As %Status
{
	Set ..SharedConnection = 1
	Set lgUserID=$g(%session.Data("LOGON.USERID"))
	Set thisWsId=..WebSocketID
	
	;记录新的链接
	Set ^TMPData("DHCNEWPRO","web.DHCPRESC","MessageWebSocketID",lgUserID)=thisWsId
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

/// w ##class(web.DHCPRESCMessageWebSocketServer).Send("Doctor","11843","0^0")
ClassMethod Send(userId, text)
{
	
	Set errMsg=0
	Set ws=##class(web.DHCPRESCWebSocketServer).%New()
	Set socketID=$g(^TMPData("DHCNEWPRO","web.DHCPRESC","MessageWebSocketID",userId))
	Quit:socketID=""
	Set %status=ws.OpenServer(socketID)
	Set %status=ws.Write(text)
	If (%status'=1){
		Set errMsg="write错误,信息"_%status
	} 
	q errMsg
}

/// Descript:结束ws
/// w ##class(web.DHCPRESCMessageWebSocketServer).ClsoeWsServerByUser(11843)
ClassMethod ClsoeWsServerByUser(UserId)
{
	Set ws=##class(web.DHCPRESCWebSocketServer).%New()
	Set socketID = $g(^TMPData("DHCNEWPRO","web.DHCPRESC","MessageWebSocketID",UserId))
	Quit:socketID=""
	Quit ws.ClsoeWsServer(socketID)
}

/// Descript:结束ws
/// w ##class(web.DHCPRESCMessageWebSocketServer).ClsoeWsServer()
Method ClsoeWsServer(socketID)
{
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
