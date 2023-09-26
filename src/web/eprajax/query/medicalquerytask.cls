Class web.eprajax.query.medicalquerytask Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s guid = $g(%request.Data("GUID",1),"")
	s frameType = $g(%request.Data("frameType",1),"")
	if (frameType = "HISUI")
	{
		s page = $g(%request.Data("page",1),"1")
		s rows = $g(%request.Data("rows",1),"10")
		s start = (page - 1) * rows
		s limit = rows
	}
	else
	{
		s start = $g(%request.Data("start",1),"0")
		s limit = $g(%request.Data("limit",1),"25")
	}
	s actionType = $g(%request.Data("actionType",1),"")
	
	s userID = $g(%request.Data("userID",1),"")
	s userName = $g(%request.Data("userName",1),"")
	s ipAddress = $g(%request.Data("ipAddress",1),"")
	s dataType = $g(%request.Data("dataType",1),"")
	s conditions = $g(%request.Data("conditions",1),"")
	s resultCol = $g(%request.Data("resultCol",1),"")
	
	if (actionType = "GetTaskDitails")
	{
		w ##class(EPRservice.BLL.Query.BLMedicalQueryTasklist).GetResultDitails(guid,start,limit)
	}
	else //记录日志
	{
		d ..SetTaskLog(actionType,userID,userName,ipAddress,dataType,conditions,resultCol)
	}
	
	Quit $$$OK
}

/// creator:     liuyunfei
/// CreatDate:   2020-10-22
/// Description: 记录病历浏览任务日志
/// Input:       userId: 操作人id
///              userName：当前操作人用户名
///              ipAddress:当前操作人ip
///              actionType：产品类型 
/// debug:       d ##class(EMRservice.BL.BLKBNode).SetTaskLog("10209","医生01","192.168.0.171","13^主诉","EMR.Knowledge.View")
ClassMethod SetTaskLog(actionType As %String, userId As %String, userName As %String, ipAddress As %String, dataType As %String, conditions As %String, resultCol As %String)
{
	s Condition = ""
	
	s Condition = Condition_"{""userId"":"""_userId_""","
	s Condition = Condition_"""userName"":"""_userName_""","
	s Condition = Condition_"""ipAddress"":"""_ipAddress_""","
	s Condition = Condition_"""dataType"":"""_dataType_""","
	s Condition = Condition_"""conditions"":"""_conditions_""","
	s Condition = Condition_"""resultCol"":"""_resultCol_"""}"
	d ##Class(EMRservice.Ajax.SetDataToEventLog).SetDataToEventLog(actionType,Condition,"")
}

}
