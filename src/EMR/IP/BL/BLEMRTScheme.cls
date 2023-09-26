/// 名称:	EMR.IP.BL.BLEMRTScheme
/// 描述:	住院病历 文档实例业务逻辑类
/// 编写者：lifengbo
/// 编写日期: 2023-03-21
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLEMRTScheme Extends EMR.IP.COM.ActionBase
{

/// Desc:       保存实例备注信息
/// Creator:    lifengbo
/// CreateDate: 2023-03-21
/// Table:		
/// Input:      argArray  命令参数 {"action":"CREATE_DOCUMENT","params":{"templateId":"68","episodeId":"660","userCode":"10209","ip":"192.168.101.37","patientId":"27","loadMode":"baseTem","userLocId":"6","happenDateTime":"","title":"","titleCode":"","userTemplateCode":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CheckCategoryInLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s (episodeID,userLocID,docCategoryCode,ssgroupID)=""
	s episodeID=argInJson.params.episodeID
	s userLocID=argInJson.params.userLocID
	s docCategoryCode=argInJson.params.docCategoryCode
	s ssgroupID=argInJson.params.ssgroupID
	
    s strRes = ##Class(EMR.IP.BL.BLEMRTScheme).CheckCategoryInLocJson(episodeID,userLocID,docCategoryCode,ssgroupID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-100")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","关键入参缺失",2)
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","备注信息添加后实例保存失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:	获取病历实例备注信息
/// Input:	
/// Return:	设置状态
/// Debug:	w ##Class(EMR.IP.BL.BLEMRTScheme).CheckCategoryInLocJson(285)
ClassMethod CheckCategoryInLocJson(argEpisodeID As %String = "", argUserLocID As %String = "", argDocCategoryCode As %String = "", argSSGroupID As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "-100"
	
	if ((argEpisodeID="")||(argUserLocID="")||(argDocCategoryCode=""))
	{
		d argOutData.Write("0")
		q strRes
	}

	s episodeType= $p(^PAADM(argEpisodeID),"^",2)
	
	if (episodeType = "I")
	{
		s disDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
		s schemType = $case(disDateTime,"":"RUNNING",:"ARCHIVING")
	}
	else
	{
		s schemType = "OUTPATIENT"
	}
	s EMRTSchemeTypeID=""
	s EMRTSchemeTypeID = $o(^CF.EMR.DOC.EMRTSchemeTypeI("IdxCode"," "_schemType,EMRTSchemeTypeID))
	
	s EMRTSchemeID=""
	s EMRTSchemeID=$o(^CF.EMR.DOC.EMRTSchemeI("IdxSchemeType",EMRTSchemeTypeID,EMRTSchemeID))
	
	s DataID=""
	s DataID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxCode"," "_argDocCategoryCode,DataID))
	s isCategoryInLoc=0
	s rowId = ""
	for
	{
		s rowId = $o(^CF.EMR.DOC.EMRTSchemeItemI("IdxSchemeItemCode",EMRTSchemeID,DataID,rowId))
		q:(rowId="")
		s objOrgItem = ##Class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(rowId)
		continue:(objOrgItem="")
		
		continue:($d(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",rowId,argSSGroupID))<=0)
		continue:($d(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",rowId,argUserLocID))<=0)
		d argOutData.Write("1")
		s isCategoryInLoc=1
		q
	}
	if (isCategoryInLoc=0) 
	{
		d argOutData.Write("0")
	}
	q 1
Error
	s $zt =""
    q "-1^"_$zerror
}

/// Desc:       获取知情告知关联的所有科室
/// Creator:    lifengbo
/// CreateDate: 2023-03-22
/// Table:		
/// Input:      argArray  命令参数 {"action":"CREATE_DOCUMENT","params":{"templateId":"68","episodeId":"660","userCode":"10209","ip":"192.168.101.37","patientId":"27","loadMode":"baseTem","userLocId":"6","happenDateTime":"","title":"","titleCode":"","userTemplateCode":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetInformedCTLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s (docCategoryCode)=""

	s docCategoryCode=argInJson.params.docCategoryCode
	
    s strRes = ##Class(EMR.IP.BL.BLEMRTScheme).GetInformedCTLocJson(docCategoryCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-100")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","关键入参缺失",2)
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","备注信息添加后实例保存失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:	获取知情告知关联的所有科室
/// Input:	
/// Return:	科室数据
/// 
/// Debug:	s argOutData = ##class(%GlobalBinaryStream).%New()
/// 			w ##Class(EMR.IP.BL.BLEMRTScheme).GetInformedCTLocJson("EMR0201",argOutData)
ClassMethod GetInformedCTLocJson(argDocCategoryCode As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "-100"
	
	if (argDocCategoryCode="")
	{
		d argOutData.Write("0")
		q strRes
	}
	s jsonArr=[]
	
	s jsonSubAll = {}
	s jsonSubAll.RowID = "ALL"
	s jsonSubAll.Code = "ALL"
	s jsonSubAll.Desc = "全院"
	d jsonArr.%Push(jsonSubAll)
	
	s arryCtLocID = ##Class(%ArrayOfDataTypes).%New()
	
	//获取所模板ID然后 从 CF.EMR.DOC.TemplateRules 获取科室信息
	
	
	
	s TemplateCategoryID=""
	s TemplateCategoryID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxCode"," "_argDocCategoryCode,TemplateCategoryID))
	
	
	s strTemplateID = ..GetTemplateIDByTplCateID(TemplateCategoryID)
	
	for i=1:1:$l(strTemplateID,",")
	{
		
		s templateId=$p(strTemplateID,",",i)
		s templateRulesID=""
		for 
		{
			s templateRulesID=$o(^CF.EMR.DOC.TemplateRulesI("TemplateIDIdx",templateId,templateRulesID))
			q:(templateRulesID="")
			
			s objTemplateRule = ""
			s objTemplateRule = ##class(CF.EMR.DOC.TemplateRules).%OpenId(templateRulesID)
			continue:(objTemplateRule="")
			if (objTemplateRule.RuleItemIDs [ "PATDEPT:")
			{
				s ctLocId = $p(objTemplateRule.RuleItemIDs,"PATDEPT:",2)
				
				s rowId =  +ctLocId
				s locCode = $p($g(^CTLOC(rowId)),"^",1)
				s locDesc = $p($g(^CTLOC(rowId)),"^",2)
				
				continue:(arryCtLocID.GetAt(rowId) '= "")
				d arryCtLocID.SetAt(rowId,rowId)
				
				s jsonSub={}
				s jsonSub.RowID = rowId
				s jsonSub.Code = locCode
				s jsonSub.Desc = locDesc
				d jsonArr.%Push(jsonSub)
			}
		}
	}
	
	d jsonArr.%ToJSON(argOutData)
	q 1
    
Error
	s $zt =""
    q "-1^"_$zerror
}

/// Debug:	w ##Class(EMR.IP.BL.BLEMRTScheme).GetTemplateIDByTplCateID()
ClassMethod GetTemplateIDByTplCateID(ATemplateCategoryID As %String) As %String
{
	q:(ATemplateCategoryID="") ""
	s listTplID=""
	s subTplCateID=""
	
	for
	{
		s subTplCateID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxParentID"," "_ATemplateCategoryID,subTplCateID))
		q:(subTplCateID="")
		
		s objTplCate=""
		s objTplCate=##class(CF.EMR.DOC.TemplateCategory).%OpenId(subTplCateID)
		continue:(objTplCate="")
		
		if (objTplCate.ResChildCount>0)
		{
	
				
			s seq=""
			for
			{
				s seq = $o(^CF.EMR.DOC.TemplateI("IdxCatSeq",subTplCateID,seq))
				q:(seq="")
				
				s tplID=""
				for
				{
					s tplID = $o(^CF.EMR.DOC.TemplateI("IdxCatSeq",subTplCateID,seq,tplID))
					q:(tplID="")
					
					s listTplID = listTplID_$lb(tplID)
					
				}
			}
			
		}
		else
		{
			s tmpRet = ..GetTemplateIDByTplCateID(subTplCateID)
			
			if (tmpRet'="")
			{
				s listTplID = listTplID_$lfs(tmpRet,",")
			}
		}
		
	}
	s retTplID= $lts(listTplID,",")
	q retTplID
}

}
