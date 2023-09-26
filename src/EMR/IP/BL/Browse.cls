/// 名称:	EMR.IP.BL.Browse
/// 描述:	病历浏览[2,3,4版]
/// 编写者：yanna
/// 编写日期: 2023-2-28
/// 产品组：电子病历产品组
Class EMR.IP.BL.Browse Extends EMR.IP.COM.ActionBase
{

/// Desc:       根据就诊号获取patientID
/// Creator:    yanna
/// CreateDate: 2023-02-28
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_CLIENTINFO","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPtIDByEpisodeID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeID = argInJson.params.episodeID
    s strRes = ..GetPtIDByEpisodeIDValue(episodeID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       根据就诊号获取patientID
/// Creator:    yanna
/// CreateDate: 2023-02-28
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_CLIENTINFO","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPtIDByEpisodeIDValue(aEpisodeID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aEpisodeID="") "-1^就诊号不能为空"
    s strMark = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(aEpisodeID)
	d argOutData.Write(strMark)
	q strRes
}

/// Desc:       根据就诊号获取科室ID
/// Creator:    yanna
/// CreateDate: 2023-02-28
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_CLIENTINFO","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDeptIDByEpisodeID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeID = argInJson.params.episodeID
    s strRes = ..GetDeptIDByEpisodeIDValue(episodeID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       根据就诊号获取科室ID
/// Creator:    yanna
/// CreateDate: 2023-02-28
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_CLIENTINFO","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDeptIDByEpisodeIDValue(aEpisodeID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aEpisodeID="") "-1^就诊号不能为空"
    s strMark = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(aEpisodeID)
    s strMark=""""_strMark_""""
	d argOutData.Write(strMark)
	q strRes
}

/// Desc:		获取病历浏览目录
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.Browse).GetBrowseCategory(76)
ClassMethod GetBrowseCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strRes = ..GetBrowseCategoryJSON(argInJson,argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:		获取病历浏览目录
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.Browse).GetBrowseCategory(76)
ClassMethod GetBrowseCategoryJSON(argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s episodeID = argInJson.params.episodeID
	s resultType = argInJson.params.resultType
	s docIDs = argInJson.params.docIDs
	s userLocID = argInJson.params.userLocID
	s ssgroupID = argInJson.params.ssgroupID
	s version = ##Class(EMR.DOC.BL.GlobalData).GetEMRVersionID(episodeID)
	s res = "1"
	if (version'=3&&(version'=4)){
		d argOutData.Write("{""type"":"""",""data"":""""}")
		q res
		} 
	if (version=3){
		d argOutData.Write("{""type"":""emr3"",")
		s strMark = ##Class(EMRservice.BL.BLClientCategory).GetBrowseCategory(episodeID,resultType,docIDs,userLocID)
		d argOutData.Write("""data"":")
		d argOutData.Write(strMark.Read())
		d argOutData.Write("}")
	}elseif (version=4){
		s dtoItem =##Class(EMR.OP.DTO.DocCategory).%New()
		s dtoItem.CTLocID = userLocID
		s dtoItem.EpisodeID = episodeID
		s dtoItem.SSGroupID = ssgroupID
		d argOutData.Write("{""type"":""emr4"",")
		d argOutData.Write("""data"":")
		d ##Class(EMR.IP.BL.ClientCategory).GetAllRecordsBrowse(dtoItem,.argOutData)
		d argOutData.Write("}")
	}
	q res
}

/// Desc:		获取病历html数据
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.Browse).GetBrowseCategory(76)
ClassMethod GetRecordHtml(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strRes = ..GetRecordHtmlJSON(argInJson,argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:		获取病历浏览数据
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.Browse).GetBrowseCategory(76)
ClassMethod GetRecordHtmlJSON(argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s res = "1"
	s recordID = argInJson.params.recordID
	s emrVersion = argInJson.params.emrVersion
	s pluginType = argInJson.params.pluginType
	if (emrVersion="emr3"){
		s strMark = ##Class(EMRservice.BLBSParseXML).GetEMRHtmlData(recordID,"bsbrowse")
		}else{
		//根据docID取json数据
		s jsonData = ##Class(%GlobalBinaryStream).%New()
		s dtoItem = ##class(EMR.DOC.DTO.DocumentData).%New()
		s arrJson = ##Class(%DynamicArray).%New()
		d arrJson.%Push(recordID)
		s dtoItem.DocumentIds = arrJson
		s dtoItem.DocType = "WORD"
		d ##Class(EMR.DOC.BL.DocumentData).LoadDocumentJson(dtoItem,.jsonData)
		s strMark = ##Class(EMRservice.BLBSParseJSON).GetEMRHtmlData(jsonData)
		}
	s resData = ##class(%DynamicObject).%New()
	s count = 0
	while (strMark.AtEnd = 0)
	{
		s tmpOut = strMark.Read(32000)
		s count = count+1
		s resData.value = resData.value_tmpOut
		;d argOutData.Write(tmpOut)
	}
	d resData.%ToJSON(argOutData)
	q res
}

/// Desc:		获取病历html数据
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.Browse).GetBrowseCategory(76)
ClassMethod GetRecordPrivilege(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strRes = ..GetRecordPrivilegeJSON(argInJson,argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取权限失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:		获取病历脚本权限
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.Browse).GetBrowseCategory(76)
ClassMethod GetRecordPrivilegeJSON(argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s res = "1"
	s emrVersion = argInJson.params.emrVersion
	s recordID = argInJson.params.recordID 
	
	s userid = argInJson.params.userid
	s userloc = argInJson.params.userloc
	s ssgroupid = argInJson.params.ssgroupid

	s patientid =  argInJson.params.patientID
	s admid =  argInJson.params.episodeID
	s sessionid =  argInJson.params.sessionID
	s documentids =  recordID
	s productcode = argInJson.product
	if (emrVersion="emr3"){
		s strMark = ##class(EMRservice.Ajax.privilege).GetBrowsePrivilege(userid,userloc,ssgroupid,admid,patientid,documentids)
		if (strMark=""){
			d argOutData.Write("""""")
			}else{
			d argOutData.Write(strMark)
			}
	}else{	
		s arrJson = ##class(%DynamicArray).%New()
		d arrJson.%Push(documentids)
		s objItem = ##class(EMR.DOC.DTO.PrivRuleData).%New()
		s objItem.userid = userid
		s objItem.userloc =  userloc
		s objItem.ssgroupid =  ssgroupid
		s objItem.patientid =  patientid
		s objItem.admid =  admid
		s objItem.sessionid =  sessionid
		s objItem.documentids =  arrJson
		s objItem.productcode = productcode
		d ##Class(EMR.OP.BL.PrivRule).GetBrowsePrivilegeJson(objItem,argOutData)
	}
	q res
Error
	q "-1^发生异常：获取权限失败"
}

/// Desc:		获取病历html数据
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.Browse).GetBrowseCategory(76)
ClassMethod GetDetaillogPart(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s product=argInJson.product
    s documentID=argInJson.params.documentID
    
	s strRes = ##Class(EMR.DOC.BL.EMRLogsView).GetDetailLogJson(product,documentID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取权限失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:		获取病历html数据
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.Browse).GetBrowseCategory(76)
ClassMethod GetDetaillogAll(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s product=argInJson.product
    s episodeID=argInJson.params.episodeID
	
    s strRes = ##Class(EMR.DOC.BL.EMRLogsView).GetAllLogJson(product,episodeID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取权限失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

}
