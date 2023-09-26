/// 名称:	EMR.DOC.BL.HFFormatStatusMLog
/// 描述:	文档版式管理日志逻辑业务
/// 编写者: duan
/// 编写日期: 	2021-03-22
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.HFFormatStatusMLog Extends EMR.DOC.COM.ActionBase
{

/// Creator：      duan
/// CreatDate：    2021-03-22
/// Description:   添加日志
/// Table：        CF.EMR.DOC.HFFormatStatusMLog
/// Input：        
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.HFFormatStatusMLog).AddMLog()
ClassMethod AddMLog(argDTO As EMR.DOC.DTO.HFFormatStatusMLog) As %String
{
	s strRes = "-1"
	s objMlog = ##class(CF.EMR.DOC.HFFormatStatusMLog).%New()
	q:(argDTO.HFVersionID ="") strRes
	s objMlog.HFVersionID = argDTO.HFVersionID
	s objMlog.HFFormatID = argDTO.HFFormatID
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
/// CreatDate：    2021-3-22
/// Description:   根据版式版本获取版本对应的最新的操作日志
/// Table：        CF.EMR.DOC.HFFormatStatusMLog
/// Input：        AHFVersionID 版式版本ID
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.HFFormatStatusMLog).GetMaxLog(2)
ClassMethod GetMaxLog(AHFVersionID As %String) As EMR.DOC.DTO.HFFormatStatusMLog
{
	s versionMlog = ##class(EMR.DOC.DTO.HFFormatStatusMLog).%New()
	s versionMlogID = $o(^CF.EMR.DOC.HFFormatStatusMLogI("IdxHFVersionID"," "_AHFVersionID,""),-1)
	q:(versionMlogID ="") versionMlog
	s objMaxMLog = ##class(CF.EMR.DOC.HFFormatStatusMLog).%OpenId(versionMlogID)
	s versionMlog.HFVersionID = objMaxMLog.HFVersionID
	s versionMlog.HFFormatID = objMaxMLog.HFFormatID
	s versionMlog.Status = objMaxMLog.Status
	s versionMlog.CreateID = objMaxMLog.CreateID
	s versionMlog.CreateDate = objMaxMLog.CreateDate
 	s versionMlog.CreateTime = objMaxMLog.CreateTime
	s versionMlog.ModifyID = objMaxMLog.ModifyID
	s versionMlog.ModifyDate = objMaxMLog.ModifyDate
	s versionMlog.ModifyTime = objMaxMLog.ModifyTime
	s versionMlog.ApplicationID = objMaxMLog.ApplicationID
	s versionMlog.ApplicationDate = objMaxMLog.ApplicationDate
	s versionMlog.ApplicationTime = objMaxMLog.ApplicationTime
	s versionMlog.AuditID = objMaxMLog.AuditID
	s versionMlog.AuditDate = objMaxMLog.AuditDate
	s versionMlog.AuditTime = objMaxMLog.AuditTime
	s versionMlog.OperateMachineIP = objMaxMLog.OperateMachineIP	
	s versionMlog.Remark = objMaxMLog.Remark		
	
	q objMaxMLog
}

/// Desc:       获取修改历史数据
/// Creator:    Ning
/// CreateDate: 2021-07-29
/// Input:      argArray  命令参数 {"action":"GET_HFFormatStatusMLog","params":{"id":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetHFFormatStatusMLog(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s HFFormatID = ..GetIDByKey(argInJson.params.id)
	s date=argInJson.params.modifyDate
	s user=argInJson.params.modifyUser
    s strRes = ##Class(EMR.DOC.BL.HFFormatStatusMLog).GetHFFormatStatusMLogJson(HFFormatID,date,user,.argOutData)
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
/// CreateDate: 2021-07-29
/// OutPut:     成功 1 失败 -200 必填项（id）未传
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
ClassMethod GetHFFormatStatusMLogJson(ID As %String, date As %String, user As %String, ByRef AOutData As %GlobalBinaryStream)
{
	q:(ID="") "-200"
    s jsonArr = ##class(%DynamicArray).%New()
 	s strBTCode = ""
	for {
		s strBTCode = $o(^CF.EMR.DOC.HFFormatStatusMLogI("IdxHFFormatID"," "_ID,strBTCode))
		q:(strBTCode = "")	
		s objMLog = ##Class(CF.EMR.DOC.HFFormatStatusMLog).%OpenId(strBTCode)
	    continue:(objMLog="")
	    s jsonMLog = ##class(%DynamicObject).%New()
	    s jsonMLog.id=strBTCode
	    s jsonMLog.HFVersionID=objMLog.HFVersionID
	    s jsonMLog.remark=objMLog.Remark
		s jsonMLog.status =objMLog.Status
		if (user'="")
		{
			continue:(objMLog.CreateID'=user)
		}
		s jsonMLog.modifyUser =objMLog.ModifyID
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
