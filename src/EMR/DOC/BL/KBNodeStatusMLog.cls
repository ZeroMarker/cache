/// 名称:	EMR.DOC.BL.KBNodeStatusMLog
/// 描述:	通用文档管理模块 Document(Doc) 文档片段 日志审核业务类
/// 编写者：duan
/// 编写日期: 2021-05-08
/// 产品组：电子病历产品组
Class EMR.DOC.BL.KBNodeStatusMLog Extends EMR.DOC.COM.ActionBase
{

/// Creator：      duan
/// CreatDate：    2021-05-10
/// Description:   添加日志
/// Table：        CF.EMR.DOC.HFFormatStatusMLog
/// Input：        
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.KBNodeStatusMLog).AddMLog()
ClassMethod AddMLog(argDTO As EMR.DOC.DTO.KBNodeStatusMLog) As %String
{
	s strRes = "-1"
	s objMlog = ##class(CF.EMR.DOC.KBNodeStatusMLog).%New()
	q:(argDTO.KBNode ="") strRes
	s ObjNode = ##class(CF.EMR.DOC.KBNode).%OpenId(argDTO.KBNode)
	s objMlog.KBNode = ObjNode
	s objMlog.Status = argDTO.Status
	s objMlog.CreateID = argDTO.CreateID
	s objMlog.CreateDate = argDTO.CreateDate
 	s objMlog.CreateTime = argDTO.CreateTime
	s objMlog.ModifyID = argDTO.ModifyID
	s objMlog.ModifyDate = argDTO.ModifyDate
	s objMlog.ModifyTime = argDTO.ModifyTime
	s objMlog.ApplicationID = argDTO.ApplicationID
	s objMlog.ApplicationDate = argDTO.ApplicationDate
	s objMlog.ApplicationTime = argDTO.ApplicationTime
	s objMlog.AuditID = argDTO.AuditID
	s objMlog.AuditDate = argDTO.AuditDate
	s objMlog.AuditTime = argDTO.AuditTime
	s objMlog.OperateMachineIP = argDTO.OperateMachineIP	
	s objMlog.Remark = argDTO.Remark		
	
	s sc = objMlog.%Save()
	if ($$$ISOK(sc))
	{
		s strRes =objMlog.%Id()
		q strRes
	}
	else
	{
		 quit strRes
	}
}

/// Creator：      duan
/// CreatDate：    2021-05-17
/// Description:   EMR.DOC.BL.KBNodeStatusMLog 增加
/// Table：        CF_EMR_DOC.KBNodeStatusMLog
/// Input：        ANodeID 片段节点ID
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.KBNodeStatusMLog).GetMaxLog(1)
ClassMethod GetMaxLog(ANodeID As %String) As EMR.DOC.DTO.KBNodeStatusMLog
{
	s dtoMlog = ##class(EMR.DOC.DTO.KBNodeStatusMLog).%New()
	q:(ANodeID ="") dtoMlog
	s strMaxMLogID = $o(^CF.EMR.DOC.KBNodeStatusMLogI("IdxKBNode",ANodeID,""),-1)
	q:(strMaxMLogID ="") dtoMlog
	s objMaxMLog = ##class(CF.EMR.DOC.KBNodeStatusMLog).%OpenId(strMaxMLogID)
	q:(objMaxMLog="") dtoMlog
	q:(objMaxMLog.KBNode="") dtoMlog
	s dtoMlog.KBNode = objMaxMLog.KBNode.%Id()
	s dtoMlog.Status = objMaxMLog.Status
	s dtoMlog.CreateID = objMaxMLog.CreateID
	s dtoMlog.CreateDate = objMaxMLog.CreateDate
 	s dtoMlog.CreateTime = objMaxMLog.CreateTime
	s dtoMlog.ModifyID = objMaxMLog.ModifyID
	s dtoMlog.ModifyDate = objMaxMLog.ModifyDate
	s dtoMlog.ModifyTime = objMaxMLog.ModifyTime
	s dtoMlog.ApplicationID = objMaxMLog.ApplicationID
	s dtoMlog.ApplicationDate = objMaxMLog.ApplicationDate
	s dtoMlog.ApplicationTime = objMaxMLog.ApplicationTime
	s dtoMlog.AuditID = objMaxMLog.AuditID
	s dtoMlog.AuditDate = objMaxMLog.AuditDate
	s dtoMlog.AuditTime = objMaxMLog.AuditTime
	s dtoMlog.OperateMachineIP = objMaxMLog.OperateMachineIP	
	s dtoMlog.Remark = objMaxMLog.Remark		
	
	q dtoMlog
}

/// Desc:       获取修改历史数据
/// Creator:    Ning
/// CreateDate: 2021-07-30
/// Input:      argArray  命令参数 {"action":"GET_KB_MLOG","params":{"id":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetKBNodeStatusMLog(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s logID = argInJson.params.id
	s user="",date=""
	s date=argInJson.params.modifyDate
	s user=argInJson.params.modifyUser
    s strRes = ##Class(EMR.DOC.BL.KBNodeStatusMLog).GetKBNodeStatusMLogJson(logID,date,user,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入版本ID",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取修改历史数据
/// Creator:    Ning
/// CreateDate: 2021-07-30
/// OutPut:     成功 1 失败 -200 必填项（id）未传
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
ClassMethod GetKBNodeStatusMLogJson(ID As %String, date As %String, user As %String, ByRef AOutData As %GlobalBinaryStream)
{
	q:(ID="") "-200"
	s strID = ..GetIDByKey(ID)
    s jsonArr = ##class(%DynamicArray).%New()
 	s strBTCode = ""
	for {
		s strBTCode = $o(^CF.EMR.DOC.KBNodeStatusMLogI("IdxKBNode",strID,strBTCode))
		q:(strBTCode = "")	
		s objMLog = ##Class(CF.EMR.DOC.KBNodeStatusMLog).%OpenId(strBTCode)
	    continue:(objMLog="")
	    s jsonMLog = ##class(%DynamicObject).%New()
	    s jsonMLog.id=strBTCode
	    s jsonMLog.KBNodeID=ID
		s jsonMLog.status =objMLog.Status
		if (user'="")
		{
			continue:(objMLog.CreateID'=user)
		}
		
		s jsonMLog.modifyUser =objMLog.ModifyID
		s jsonMLog.remark=objMLog.Remark
		s jsonMLog.ip=objMLog.OperateMachineIP
		s jsonMLog.modifyDate =$zd(objMLog.ModifyDate,3)
		if (date'="")
		{
			continue:( jsonMLog.modifyDate'=date)
		}
		
		s jsonMLog.modifyTime=$zt(objMLog.ModifyTime)
		
		d jsonArr.%Push(jsonMLog)		
		
	}
	
	d jsonArr.%ToJSON(AOutData)

	q "1"
}

/// Desc:       截取id值
/// Creator:    ning
/// CreateDate: 2021-11-18
/// Input:      argKey 返回给前端的拼接key，拼接格式:id(节点id)-type(节点类型)
/// OutPut:     argOutMessage 返回消息json格式
///            	string 返回1 成功
ClassMethod GetIDByKey(argKey As %String = "") As %String
{
	q:(argKey="") ""
	if (argKey ["||"){
		s id = $P(argKey,"||",1)
	}else{
		s id = argKey	
	}
	
	q id
}

}
