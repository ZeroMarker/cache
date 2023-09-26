Class web.DHCPRESCNewsWs Extends %CSP.WebSocket
{

Method OnPreServer() As %Status
{
	Set UserType=$Get(%request.Data("userType",1),"")
	Set LgHospID=$g(%session.Data("LOGON.HOSPID"))
	Set LgLocID=$g(%session.Data("LOGON.CTLOCID"))
	Set LgGroupID=$g(%session.Data("LOGON.GROUPID"))
	Set LgUserID=$g(%session.Data("LOGON.USERID"))
	Set ^TMPData("DHCNEWPRO","WebSocketID",UserType,LgUserID)=..WebSocketID
	Set ^TMPData("WebSocketID",..WebSocketID)=""
	Set ..SharedConnection = 1	;异步交互
    Quit $$$OK
}

Method Server() As %Status
{
	Set timeout=10
	For  {
		Set len=32656
		Set data=..Read(.len, .status, timeout)

		If $$$ISERR(status) {
			
		}else {
			If data="exit" Quit
			d ..WriteMes(data)
		}
	}
	Set status=..EndServer()
	Quit $$$OK
}

Method WriteMes(data)
{
	s toUserType=$p(data,$c(1),1)
	s lgParams=$p(data,$c(1),2)
	s lgUserId=$p(lgParams,"^",4)
	s text=$p(data,$c(1),3)
	Set errMsg=""
	
	
	Set ws=##class(web.DHCPRESCNewsWs).%New()
	Set socketID=0
	For {
		Set socketID=$o(^TMPData("WebSocketID",socketID))
		Quit:socketID=""
		Set %status=ws.OpenServer(socketID)
		If (%status'=1){
			k ^TMPData("WebSocketID",socketID)
			Continue
		}
		b ;errData
		If (ws.SessionId=""){
			k ^TMPData("WebSocketID",socketID)
			Continue
		}
		Set %status=ws.Write(data)
		If (%status'=1){
			Set errMsg="write错误,信息"_%status
		}
	} 
	q errMsg
}

/// w ##class(web.MyWebSocketServer).WriteMesToAllServer("33")
ClassMethod WriteMesToAllServer(data)
{
	s ^qqa("WriteMesToAllServer")=data
	Set errMsg=""
	Set ws=##class(web.MyWebSocketServer).%New()
	Set socketID=0
	For {
		Set socketID=$o(^TMPData("WebSocketID",socketID))
		Quit:socketID=""
		Set %status=ws.OpenServer(socketID)
		If (%status'=1){
			k ^TMPData("WebSocketID",socketID)
			Continue
		}
		b ;errData
		If (ws.SessionId=""){
			k ^TMPData("WebSocketID",socketID)
			Continue
		}
		Set %status=ws.Write(data)
		If (%status'=1){
			Set errMsg="write错误,信息"_%status
		}
	} 
	q errMsg
}

Method OnPostServer() As %Status
{
   Quit $$$OK
}

}
