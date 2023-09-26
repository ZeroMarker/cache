/// 名称:	EMR.IP.BL.BLToolNav
/// 描述:	住院病历 病历导航工具栏系统参数
/// 编写者：lifengbo
/// 编写日期: 2023-03-19
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLToolNav Extends EMR.IP.COM.ActionBase
{

Parameter ClassName = "EMR.IP.BL.BLToolNav";

/// Desc:       获取导航页工具栏需要的系统参数 GET_TOOLNAV_SYSOPTION
/// Creator:    lifengbo
/// CreateDate: 2023-03-08
/// Input:      argArray  命令参数  {"action":"GET_TOOLNAV_SYSOPTION","params":{},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetToolNavSysOption(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{

	s $zt = "Error"
    s strRes = ##Class(EMR.IP.BL.BLToolNav).GetToolNavSysOptionJson(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(+strRes = "-500")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","程序异常:"_$ze,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","GetToolNavSysOptionJson返回值异常",2)
	}
Error
	s $zt = ""
	q ..SetOutMessage(argOutMessage,"ERROR","GetToolNavSysOption异常："_$ze,2)
}

/// Desc:	获取导航页工具栏需要的系统参数 GET_TOOLNAV_SYSOPTION
/// Creator:    lifengbo
/// CreateDate: 2023-03-19
/// Input:	
/// Return:	json: {moveText ,isEnableRevokeComplete ,isSubmitRemarks, isOpenEvent }
/// Debug:	s argOutData = ##class(%GlobalBinaryStream).%New()
/// 		w ##Class(EMRservice.BL.BLPatSign).GetToolNavSysOptionJson(.argOutData)
ClassMethod GetToolNavSysOptionJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s json={}
	s json.moveText = ""
	s json.isEnableRevokeComplete= ""
	s json.isSubmitRemarks= ""
	s json.isOpenEvent = ""
	
	
	s moveText= ##class(EMR.IP.BL.BLSysOption).GetOptionValueByName("CrisisRolling","Y")
	s isEnableRevokeComplete= ##class(EMR.IP.BL.BLSysOption).GetOptionValueByName("isEnableRevokeComplete","Y")
	s isSubmitRemarks= ##class(EMR.IP.BL.BLSysOption).GetOptionValueByName("isSubmitRemarks","N")
	s isOpenEvent= ##class(EMR.IP.BL.BLSysOption).GetOptionValueByName("isOpenEvent","N")
	
	
	s json.moveText = moveText
	s json.isEnableRevokeComplete= isEnableRevokeComplete
	s json.isSubmitRemarks= isSubmitRemarks
	s json.isOpenEvent = isOpenEvent
	
	d json.%ToJSON(argOutData)
	
	q 1
}

/// Desc:       获取列表视图所需的系统参数 GET_NAVLIST_SYSOPTION
/// Creator:    lifengbo
/// CreateDate: 2023-03-19
/// Input:      argArray  命令参数  {"action":"GET_NAVLIST_SYSOPTION","params":{},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetNavListSysOption(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s userLocId="",episodeId=""
	s userLocId=argInJson.params.userLocID
	s episodeId=argInJson.params.episodeID
	
    s strRes = ##Class(EMR.IP.BL.BLToolNav).GetNavListSysOptionJson(userLocId,episodeId,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(+strRes = "-500")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","程序异常:"_$ze,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","GetNavListSysOptionJson异常编码",2)
	}
Error
	s $zt = ""
	q ..SetOutMessage(argOutMessage,"ERROR","GetNavListSysOption程序异常:"_$ze,2)
}

/// Desc:	获取列表视图所需的系统参数 GET_NAVLIST_SYSOPTION
/// Creator:    lifengbo
/// CreateDate: 2023-03-19
/// Input:	argUserLocId, argEpisodeID
/// Return:	1 正常  
/// Debug:	s argOutData = ##class(%GlobalBinaryStream).%New()
/// 			w ##Class(EMR.IP.BL.BLToolNav).GetNavListOptionJson(191,287,.argOutData)
ClassMethod GetNavListSysOptionJson(argUserLocId As %String, argEpisodeID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt="ERROR"
	s json={}
	s json.createAdvance = ""
	s json.isLoadDocument= ""
	s json.openDiseaseTemp= ""
	s json.diagnosInfo = ""
	s json.isPatCAOn = ""
	s json.isCollapse = ""
	
	
	s createAdvance= ##class(EMR.IP.BL.BLSysOption).GetOptionValueByName("ENABLE_ADVANCE_DAILYRECORD")
	s isLoadDocument= ##class(EMR.IP.BL.BLSysOption).GetOptionValueByName("isLoadDocument","Y")
	s openDiseaseTemp= ##class(EMR.IP.BL.BLSysOption).GetOptionValueByName("openDiseaseTemp","Y")
	s diagnosInfo= ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(argEpisodeID) 
	
	//需要传入hospital
	s hospID = ""
    s:(argUserLocId '= "") hospID = $P($G(^CTLOC(argUserLocId)),"^",22)
    
    
	s isPatCAOn= ##class(EMR.IP.BL.BLCAService).CAHandSign(hospID)

	
	//系统参数目录树展开或者折叠。返回0/1
	s isCollapse=##class(EMR.IP.BL.BLSysOption).GetOptionValueByName("isCollapse",0)
	
	s json.createAdvance = createAdvance
	s json.isLoadDocument= isLoadDocument
	s json.openDiseaseTemp= openDiseaseTemp
	s json.diagnosInfo = diagnosInfo
	s json.isPatCAOn = isPatCAOn
	s json.isCollapse = isCollapse
	
	d json.%ToJSON(argOutData)
	
	q 1
ERROR
	s $zt = ""
	s error = "-500"
	q error
}

}
