/// 名称:EMR.DOC.COM.TemplateStatusMLog
/// 描述:通用文档管理模块 Document(Doc) 公用程序层 TemplateStatusMLog 模板状态管理维护业务类
///      使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除
/// 编写者：Guozongtao@mediway.cn
/// 编写日期: 2020-07-08
/// 产品组：电子病历产品组
Class EMR.DOC.BL.TemplateStatusMLog Extends EMR.DOC.COM.ActionBase
{

/// Creator：      yejian
/// CreatDate：    2021-1-11
/// Description:   TemplateStatusMLog 增加
/// Table：        CF_EMR_DOC.TemplateStatusMLog
/// Input：        
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.TemplateStatusMLog).AddMLog()
ClassMethod AddMLog(argDTO As EMR.DOC.DTO.TemplateStatusMLog) As %String
{
	s strRes = "-1"
	s objMlog = ##class(CF.EMR.DOC.TemplateStatusMLog).%New()
	q:(argDTO.TemplateVersion ="") strRes
	s objTemVersion = ##class(CF.EMR.DOC.TemplateVersion).%OpenId(argDTO.TemplateVersion)
	s objMlog.TemplateVersion = objTemVersion
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

/// Creator：      yejian
/// CreatDate：    2021-1-11
/// Description:   TemplateStatusMLog 增加
/// Table：        CF_EMR_DOC.TemplateStatusMLog
/// Input：        aTemplateVersionID 文档版本ID
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.TemplateStatusMLog).GetMaxLog(1)
ClassMethod GetMaxLog(aTemplateVersionID As %String) As EMR.DOC.DTO.TemplateStatusMLog
{
	s dtoMlog = ##class(EMR.DOC.DTO.TemplateStatusMLog).%New()
	q:(aTemplateVersionID ="") dtoMlog
	s strMaxMLogID = $o(^CF.EMR.DOC.TemplateStatusMLogI("IdxTemplateVersion",aTemplateVersionID,""),-1)
	q:(strMaxMLogID ="") dtoMlog
	s objMaxMLog = ##class(CF.EMR.DOC.TemplateStatusMLog).%OpenId(strMaxMLogID)
	s dtoMlog.TemplateVersion = objMaxMLog.TemplateVersion.%Id()
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
/// CreateDate: 2021-07-21
/// Input:      argArray  命令参数 {"action":"GET_TemplateStatusMLog","params":{"id":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTemplateStatusMLog(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s user="",date=""
	s date=argInJson.params.modifyDate
	s user=argInJson.params.modifyUser
	s templateID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.TemplateStatusMLog).GetTemplateStatusMLogJson(templateID,date,user,.argOutData)
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
/// CreateDate: 2021-07-21
/// OutPut:     成功 1 失败 -200 必填项（id）未传
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
ClassMethod GetTemplateStatusMLogJson(ID As %String, date As %String, user As %String, ByRef AOutData As %GlobalBinaryStream)
{
	q:(ID="") "-200"
    s jsonArr = ##class(%DynamicArray).%New()
 	
 	
 	// 获取所有版本
 	s versionNumber=""
 	&sql(select max(TepmplateVersionNumber) into :versionNumber from CF_EMR_DOC.TemplateVersion where Template = :ID)
 	for i=1:1:versionNumber
 	{
	 	s rowID=""
	 	&sql(select ID into :rowID from CF_EMR_DOC.TemplateVersion where Template= :ID and TepmplateVersionNumber = :i)
	 	s objVersion=##class(CF.EMR.DOC.TemplateVersion).%OpenId(rowID)
	 	s strBTCode = ""
	 	for {
		s strBTCode = $o(^CF.EMR.DOC.TemplateStatusMLogI("IdxTemplateVersion",rowID,strBTCode))
		q:(strBTCode = "")	
		s objMLog = ##Class(CF.EMR.DOC.TemplateStatusMLog).%OpenId(strBTCode)
		
	    continue:(objMLog="")
	    if (user'="")
		{
			continue:(objMLog.CreateID'=user)
		}
		
		
	    s jsonMLog = ##class(%DynamicObject).%New()
	    s jsonMLog.id=strBTCode
	    s jsonMLog.templateVersion="V"_i_".0 "_$ZD(objMLog.ModifyDate,3)
		s jsonMLog.status =objMLog.Status
		s jsonMLog.ip=objMLog.OperateMachineIP
		s jsonMLog.remark=objMLog.Remark
		s jsonMLog.modifyUser =objMLog.ModifyID
		s jsonMLog.modifyDate =$zd(objMLog.ModifyDate,3)
		if (date'="")
		{
			continue:( jsonMLog.modifyDate'=date)
		}
		s jsonMLog.modifyTime =$zt(objMLog.ModifyTime)
		d jsonArr.%Push(jsonMLog)		
	}
	 }
	
	
	d jsonArr.%ToJSON(AOutData)

	q "1"
}

/// w ##Class(EMR.DOC.COM.TemplateStatusMLog).Test()
ClassMethod Test() As %String
{
	s ReturnValue = ""
	
	s objDTO  = ##class(EMR.DOC.DTO.TemplateStatusMLog).%New()
	
	s objDTO.TemplateCode = "EMR090001" 
	s objDTO.TepmplateVersionNumber = 1
	s objDTO.Status = 2
	
	s objDTO.CreateID = 1
	s objDTO.CreateDate = +$h
	s objDTO.CreateTime = $p($h,",",2)
	
	s objDTO.ModifyID = 2
	s objDTO.ModifyDate = +$h
	s objDTO.ModifyTime = $p($h,",",2)
	
	s objDTO.ApplicationID = 3
	s objDTO.ApplicationDate = +$h
	s objDTO.ApplicationTime = $p($h,",",2)
	
	s objDTO.AuditID = 4
	s objDTO.AuditDate = +$h
	s objDTO.AuditTime = $p($h,",",2)
	
	s objDTO.OperateMachineIP = "192.168.0.1"	
	s objDTO.Remark = "Remark"	
	
	s ReturnValue =  ..AddMLog(objDTO)
	
	q ReturnValue
}

}
