/// 名称:	EMR.IP.BL.BLDHCEvent
/// 描述:	审计日志相关代码
/// 编写者：lifengbo
/// 编写日期: 2023-04-13
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DHCEventLogConfig Extends EMR.IP.COM.ActionBase
{

/// Desc:       审计日志相关代码
/// Creator:    lifengbo
/// CreateDate: 2023-04-03
/// Input:      argArray  命令参数  {"action":"GET_PATDISEASE","params":{episodeID},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SetEventLog(argInJson As %DynamicAbstractObject)
{
	s $zt = "Error"
	s episodeId=""
	s action =argInJson.action
	s isEventLog = ..checkNeedEventLog(action)
	q:(isEventLog=0) 1
	///审计日志记录登录配置表
	s condition=argInJson.params
    s modelName = ..GetModelNameByAction(action)
    s secCode=..GetSecCode(argInJson.params.epidsodeID)
	
    s strRes = ##Class(EMR.DOC.BL.DHCEventLogConfig).SetEventLogJson(modelName,condition,condition,secCode)
	if (strRes'=1)
	{
		q "-1^"
	}
	q 1
Error
	q "-1^审计服务异常"_$ze
}

/// Desc:	审计日志相关代码
/// Creator:    lifengbo
/// CreateDate: 2023-04-18
/// Input:	argModelName,基础平台EventLog编码
/// Return:	
/// Debug:	w ##Class(EMR.DOC.BL.DHCEventLogConfig).SetEventLogJson("EMR.Save",……)
ClassMethod SetEventLogJson(argModelName As %String, argCondition As %DynamicAbstractObject, argContent As %DynamicAbstractObject, argSecCode As %String) As %String
{

	s strRes ="-100"
	q:(argModelName="") strRes_"^缺失基础平台审计编码"
	
	s $zt = "ERROR"

	s Systemdatetime = $HOROLOG
	s Systemdateint = $p(Systemdatetime,",",1)
	s Systemtimeint = $p(Systemdatetime,",",2)
	s actionDate = $zd(Systemdateint,3)
	s actionTime = $zt(Systemtimeint,3)
	

	d argContent.%Set("actionDate",actionDate)
	d argContent.%Set("actionTime",actionTime)
	

	s ipAddress = argCondition.ipAddress
	
	d ##Class(web.DHCEventLog).EventLog(argModelName,argCondition.%ToJSON(),argContent.%ToJSON(),argSecCode,"Y","",ipAddress)
	
	
	q 1
ERROR
	q "-1^"_$ze
}

/// Desc:	校验病历Action是否需推送审计日志
/// Creator:    lifengbo
/// CreateDate: 2023-04-18
/// Input:	argAction,病历当前操作编码
/// Return:	
/// Debug:	w ##Class(EMR.DOC.BL.DHCEventLogConfig).checkNeedEventLog("SAVE_DOCUMENT")
ClassMethod checkNeedEventLog(argAction As %String) As %String
{
	s isNeed= 0 
	q:(argAction="") isNeed

	s eventLogCFId=""
	for{
		s eventLogCFId = $o(^CF.EMR.DOC.DHCEventLogConfigI("IdxAction"," "_$zcvt(argAction,"U"),eventLogCFId))
		q:(eventLogCFId="")
		
		s objEventLogCFId = ##class(CF.EMR.DOC.DHCEventLogConfig).%OpenId(eventLogCFId)
		continue:(objEventLogCFId.IsActive '="Y")
		s isNeed =1
		q 
	}
	q isNeed
}

/// Desc:	校验病历Action是否需推送审计日志
/// Creator:    lifengbo
/// CreateDate: 2023-04-18
/// Input:	argAction,病历当前操作编码
/// Return:	
/// Debug:	w ##Class(EMR.DOC.BL.DHCEventLogConfig).GetModelNameByAction("SAVE_DOCUMENT")
ClassMethod GetModelNameByAction(argAction As %String) As %String
{
	s modelName=""
	q:(argAction="") modelName

	s eventLogCFId=""
	for{
		s eventLogCFId = $o(^CF.EMR.DOC.DHCEventLogConfigI("IdxAction"," "_$zcvt(argAction,"U"),eventLogCFId))
		q:(eventLogCFId="")
		s objEventLogCFId = ##class(CF.EMR.DOC.DHCEventLogConfig).%OpenId(eventLogCFId)
		continue:(objEventLogCFId.IsActive'="Y")
		s modelName=objEventLogCFId.DHCEventCode
		q
	}
	q modelName
}

ClassMethod GetSecCode(argEpisodeID As %String) As %String
{
	q:(argEpisodeID) "" 
	//患者密级
	s SecurityData= ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetSecurity(argEpisodeID)
	s secCode = $p(SecurityData,"^",3)
	
	q secCode
}

}
