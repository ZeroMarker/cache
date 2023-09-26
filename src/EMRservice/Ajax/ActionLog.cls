Class EMRservice.Ajax.ActionLog Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s errInfo=""
	s $zt = "ErrorHandler"
	s func = $g(%request.Data("func",1),"") 
	if (func = "saveActionLog")
	{
		s log = ##Class(EMRinstance.Events.ActionLog).%New()
		s log.UsrID = $g(%request.Data("UsrID",1),"")
		s log.UsrLoc = $g(%request.Data("UsrLoc",1),"")
		s log.Action = $g(%request.Data("Action",1),"")
		s log.EMRTemplate = $g(%request.Data("EMRTemplate",1),"")
		s log.IP = ..getLoginIP(log.UsrID)
    	s log.LogDate=$p($h, ",", 1)
    	s log.LogTime=$p($h, ",", 2)
		d log.%Save()
	}
	elseif (func = "AddActionLog")
	{
		s userId = $g(%request.Data("UserID",1),"")
		s userLocId = $g(%request.Data("UserLocID",1),"")
		s action = $g(%request.Data("Action",1),"")
		s content = $g(%request.Data("Content",1),"")
		s ip = $g(%request.Data("IP",1),"")
		s:(ip = "") ip = ..getLoginIP(userId)
		s result = ..AddActionlog(userId,userLocId,action,content,ip)
		w result	
	}
	Quit $$$OK
ErrorHandler
   //w "{""Err"":"""_errInfo_"_"_$zerror_"""}"
   w ""
   Quit $$$OK
}

/// w ##Class(EMRservice.Ajax.ActionLog).getLoginIP("876")
/// 获取登录时候记录的IP地址
ClassMethod getLoginIP(LOGUserDR As %String) As %String
{
	q:(LOGUserDR="") ""
	//^SST("LOG",0,"User",{LOG_User_DR},{LOG_LogonDate},{LOG_LogonTime},{LOG_RowId})
	
	s LOGLogonDate = $O(^SST("LOG",0,"User",LOGUserDR,""),-1)
	q:(LOGLogonDate="") ""
	
	s LOGLogonTime = $O(^SST("LOG",0,"User",LOGUserDR,LOGLogonDate,""),-1)
	q:(LOGLogonTime="") ""
	
	s LOGRowId = $O(^SST("LOG",0,"User",LOGUserDR,LOGLogonDate,LOGLogonTime,""),-1)
	q:(LOGRowId="") ""
	
	s id = $O(^User.DHCClientLoginI("UserLoginIndex"," "_LOGRowId,""))
	q:(id="") ""
	
	s obj = ##Class(User.DHCClientLogin).%OpenId(id)
	q obj.DHCCLComputerIp
}

/// Desc:      记录用户操作行为
/// Creator:   Candy
/// CreateDate:2015-1-30
/// Input:     AUserID 登录用户ID
///           AUserLocID 登录用户科室ID
///           AAction 动作
///           AContent 操作内容
///           AIp 登录IP地址
/// Output:    Result 1成功，0失败
ClassMethod AddActionlog(AUserID As %String, AUserLocID As %String, AAction As %String, AContent As %String, AIp As %String) As %String
{
	s result = "0"
	q:((AUserID = "")||(AAction = "")) result
	s objActionLog = ##Class(EMRinstance.Trace.ActionLog).%New()
	s objActionLog.UserID = AUserID
	s objActionLog.UserLocID = AUserLocID
	s objActionLog.Action = AAction
	s objActionLog.IP = AIp
	s objActionLog.Content = AContent
	s objActionLog.LogDate = $p($h, ",", 1)
	s objActionLog.LogTime = $p($h, ",", 2)
	s:($$$ISOK(objActionLog.%Save())) result = "1"
	q result
}

}
