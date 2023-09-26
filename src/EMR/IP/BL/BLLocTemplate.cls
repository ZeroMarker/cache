/// 名称:	EMR.IP.BL.BLLocTemplate
/// 描述:	住院病历 文档实例业务逻辑类
/// 编写者：lifengbo
/// 编写日期: 2023-03-21
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLLocTemplate Extends EMR.IP.COM.ActionBase
{

/// Desc:       保存实例备注信息
/// Creator:    lifengbo
/// CreateDate: 2023-03-21
/// Table:		
/// Input:      argArray  命令参数 {"action":"CREATE_DOCUMENT","params":{"templateId":"68","episodeId":"660","userCode":"10209","ip":"192.168.101.37","patientId":"27","loadMode":"baseTem","userLocId":"6","happenDateTime":"","title":"","titleCode":"","userTemplateCode":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetLocTemplateCTLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s documentID="", memoText=""
	
	s userID=argInJson.params.userID
	s userLocID=argInJson.params.userLocID
	s episodeID=argInJson.params.episodeID
	s docCategoryCode=argInJson.params.docCategoryCode
	s text=argInJson.params.text
	
    s strRes = ##Class(EMR.IP.BL.BLLocTemplate).GetLocTemplateCTLocJson(docCategoryCode,text,episodeID,userID,userLocID,.argOutData)
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
/// Debug:	s argOutData = ##class(%GlobalBinaryStream).%New()
/// Debug:	w ##Class(EMR.IP.BL.BLLocTemplate).GetLocTemplateCTLocJson("EMR090001","",285,18881,191,.argOutData)
ClassMethod GetLocTemplateCTLocJson(argDocCategoryCode As %String, argText As %String = "", argEpisodeID As %String, argUserID As %String, argUserLocID As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "-100"
	
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
	q:(TemplateCategoryID="") strRes
	
	s strTemplateID = ..GetTemplateIDByTplCateID(TemplateCategoryID)
	
	q:(strTemplateID="") strRes
	
	for i=1:1:$l(strTemplateID,",")
	{
		s templateId = $p(strTemplateID,",",i)
		
		s strLocTemplateID = ..GetLocTemplateIDByTplID(templateId)
		continue:(strLocTemplateID="")
		for j=1:1:$l(strLocTemplateID,",")
		{
			
			s LocTemplateId=$p(strLocTemplateID,",",j)
			
			s LocTemplateRulesID=""
			for 
			{
				s LocTemplateRulesID=$o(^CF.EMR.DOC.LocTemplateRulesI("TemplateIDIdx",LocTemplateId,LocTemplateRulesID))
				q:(LocTemplateRulesID="")
				
				s objLocTemplateRule = ""
				s objLocTemplateRule = ##class(CF.EMR.DOC.LocTemplateRules).%OpenId(LocTemplateRulesID)
				continue:(objLocTemplateRule="")
				if (objLocTemplateRule.RuleItemIDs [ "PATDEPT:")
				{
					s ctLocId = $p(objLocTemplateRule.RuleItemIDs,"PATDEPT:",2)
					
					s rowId =  +ctLocId
					s locCode = $p($g(^CTLOC(rowId)),"^",1)
					s locDesc = $p($g(^CTLOC(rowId)),"^",2)
					continue:((argText'="")&&'(locDesc[argText))
					
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

	if ($d(^CF.EMR.DOC.TemplateCategoryI("IdxParentID"," "_ATemplateCategoryID))=10)
	{
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
	}
	else
	{
		s objTplCate=##class(CF.EMR.DOC.TemplateCategory).%OpenId(ATemplateCategoryID)

		if (objTplCate.ResChildCount>0)
		{	
			s seq=""
			for
			{
				s seq = $o(^CF.EMR.DOC.TemplateI("IdxCatSeq",ATemplateCategoryID,seq))
				q:(seq="")
				
				s tplID=""
				for
				{
					s tplID = $o(^CF.EMR.DOC.TemplateI("IdxCatSeq",ATemplateCategoryID,seq,tplID))
					q:(tplID="")
					
					s listTplID = listTplID_$lb(tplID)
					
				}
			}
			
		}
	}
	s retTplID= $lts(listTplID,",")
	q retTplID
}

/// Debug:	w ##Class(EMR.IP.BL.BLEMRTScheme).GetTemplateIDByTplCateID()
ClassMethod GetLocTemplateIDByTplID(ATemplateID As %String) As %String
{
	q:(ATemplateID="") ""
	s listLocTplID=""
	
	s locTplID=""
	for
	{
		s locTplID = $o(^CF.EMR.DOC.LocTemplateI("IdxTemplate",ATemplateID,locTplID))
		q:(locTplID="")
		
		s objLocTpl=""
		s objLocTpl=##class(CF.EMR.DOC.LocTemplate).%OpenId(locTplID)
		continue:(objLocTpl="")
		//验证科室模板为发布状态
		continue:(+objLocTpl.TempPublishVersion=0)
		//验证科室模板审核通过 状态值为2，其他数据不展示
		s objLocTemplateVersion= ##class(CF.EMR.DOC.LocTemplateVersion).%OpenId(objLocTpl.TempPublishVersion)
		continue:(objLocTemplateVersion="")||(objLocTemplateVersion.Status'=2)
		
		s listLocTplID = listLocTplID_$lb(locTplID)

		
	}
	s retLocTplID= $lts(listLocTplID,",")
	q retLocTplID
}

/// Desc:       根据模板目录信息组合为二位数组(主键父ID，值为第一层子节点ID数组)
/// Creator:    yejian(lifengbo)
/// CreateDate: 2021-7-30
/// Input:      jsonTem 模板json对象
/// 			arrData 需要构建的JSON数据
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.IP.BL.BLLocTemplate).GetJsonDataByTemJson("",.argOutData)
ClassMethod GetJsonDataByTemJson(jsonTem As %DynamicAbstractObject, ByRef arrGroup As %ArrayOfDataTypes) As %String
{
	
	s strPids = jsonTem.pids
	s strFid = 0
	//为空表示没有目录
	if (strPids'="")
	{
		s countCat =$l(strPids,"^")
		for i=1:1:countCat
		{
			s strPid = $p(strPids,"^",i)
			continue:(strPid = "")
			s arrids =  arrGroup.GetAt(strFid)
			//如果为空，创建JSON数组
			if (arrids="") 
			{
				s arrids = ##class(%DynamicArray).%New()
				d arrids.%Push(strPid)
			}
			else
			{
				s strJson = arrids.%ToJSON()
				d:(strJson '[ (""""_strPid_"""")) arrids.%Push(strPid)
			}
			d arrGroup.SetAt(arrids,strFid)
			s strFid = strPid
		}
		s arrTems =  arrGroup.GetAt(strPid)
		s:(arrTems="") arrTems = ##class(%DynamicArray).%New()
		d arrTems.%Push(jsonTem)
		d arrGroup.SetAt(arrTems,strPid)
	}
	else
	{
		s arrTems =  arrGroup.GetAt(strFid)
		s:(arrTems="") arrTems = ##class(%DynamicArray).%New()
		d arrTems.%Push(jsonTem)
		d arrGroup.SetAt(arrTems,strFid)
	}
	q 1
}

/// Desc:		递归获取模板JSON数据
/// Creator:	yejian (lifengbo)
/// CreateDate:	2021-8-11
/// Input:      jsonData 文档json数据
///             argOutData 转换后的流数据
/// Output:    	成功1、失败-1
/// Debug: 		d ##class(EMR.OP.BL.LocTemplate).GetJsonData(0,"","")
ClassMethod GetJsonData(aKey As %String, arrData As %ArrayOfDataTypes, ByRef ajsonP As %DynamicAbstractObject) As %String
{
	s result = "1"
	s ids = arrData.GetAt(aKey)
	q:(ids="")
	set iter = ids.%GetIterator()
	s jsonArr = ##class(%DynamicArray).%New()
	while iter.%GetNext(.index , .jitem ) {
        s strValue = jitem
        q:(strValue="")
        s strType = ids.%GetTypeOf(index)
        //模板数据为json对象
		if (strType="object")||(strType="array")
		{
			d jsonArr.%Push(strValue)
		}
		else //数字为目录
		{
			s objCat = ##class(CF.EMR.DOC.LocTemplateCategory).%OpenId(strValue)
			continue:(objCat="")
			s jsonCat = ##class(%DynamicObject).%New()
			s jsonCat.id="flod-"_strValue
			s jsonCat.type="flod"
			s jsonCat.text=objCat.Name
			s jsonCat.state="closed"
			s jsonCat.pid=strValue
			s jsonCat.icon=""
			d jsonArr.%Push(jsonCat)			
			d ##class(EMR.OP.BL.LocTemplate).GetJsonData(strValue,arrData,.jsonCat)
		}
	}
	s ajsonP.children =jsonArr
	q result
}

/// Desc:       根据模板ID获取科室模板ID集合
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 病历导航入参对象
/// 			arrTemIds 模板JSON数组
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.LocTemplateCategory).GetTemIDByRecordID("YS01","TEMPLATE",.argOutData)
ClassMethod GetLocTemIDByRecordID(dtoItem As EMR.OP.DTO.DocCategory, arrTemIds As %DynamicArray) As %DynamicArray
{
	s jsonLocTemp = ##class(%DynamicArray).%New()
	
	set iter = arrTemIds.%GetIterator()
	s parentid = -100000000000000
	while iter.%GetNext(.key , .item ) {
        s jsonTem = item
        continue:(jsonTem = "")||(jsonTem.templateID="")
		s objTem = ##Class(CF.EMR.DOC.Template).%OpenId(jsonTem.templateID)
	    continue:(objTem="")
	    s strRes = ##class(EMR.IP.BL.BLLocTemplate).GetJsonCategroyByID(jsonTem.templateID,"",jsonTem,"",.jsonLocTemp)
		s strRes = ##Class(EMR.IP.BL.BLLocTemplate).GetJsonLocTempalteByCID(jsonTem.templateID,-100000000000000,jsonTem,"",.jsonLocTemp)
	    
	}
	
	q jsonLocTemp
}

/// Desc:       递归获取模板目录数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aTemplateId 模板ID
/// 				aParentId 目录ID
///             aProduct 项目标识
///             aPids 目录id串1^2^3
/// Output:    成功 1，失败 -1 
/// 	Debug:	q ##Class(EMR.OP.BL.LocTemplateCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aTemplateId As %String, aParentId As %String, jsonTem As %DynamicAbstractObject, ByRef aPids As %String, ByRef jsonLocTemp As %DynamicAbstractObject) As %String
{
	s res = "1"
	s arrCategory = ##CLASS(%DynamicArray).%New()

	s strSeq= ""	
	for {
		s strSeq = $o(^CF.EMR.DOC.LocTemplateCatI("IdxPidSeq",aTemplateId," "_aParentId,strSeq))
		q:(strSeq = "")	
		s strCId = $o(^CF.EMR.DOC.LocTemplateCatI("IdxPidSeq",aTemplateId," "_aParentId,strSeq,""))
		q:(strCId = "")		
		s objLocTemCat = ##Class(CF.EMR.DOC.LocTemplateCategory).%OpenId(strCId)
	    continue:(objLocTemCat="")
	    
		s aPids = $case(aPids,"":strCId,:(aPids_"^"_strCId))
		s result = ##Class(EMR.IP.BL.BLLocTemplate).GetJsonCategroyByID(aTemplateId,strCId,jsonTem,aPids,.jsonLocTemp)
		s result = ##Class(EMR.IP.BL.BLLocTemplate).GetJsonLocTempalteByCID(aTemplateId,strCId,jsonTem,aPids,.jsonLocTemp)
		
	}
	q res
}

/// Desc:       获取科室模板数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aTemplateId 模板ID
/// 	        aParentId 目录ID
///             aProductid 项目标识
///             aPids 目录id串1^2^3
/// Output:     q ##Class(EMR.IP.BL.BLLocTemplate).GetJsonLocTempalteByCID(0,1,1,)
ClassMethod GetJsonLocTempalteByCID(aTemplateId As %String, aParentId As %String, jsonRecord As %DynamicAbstractObject, ByRef aPids As %String, ByRef jsonTemplate As %DynamicAbstractObject) As %String
{
	s res = "1"
	s strSeq = ""
	for {
		s strSeq = $o(^CF.EMR.DOC.LocTemplateI("IdxCatSeq",aTemplateId,aParentId,strSeq))
		q:(strSeq = "")			
		s strRowID = $o(^CF.EMR.DOC.LocTemplateI("IdxCatSeq",aTemplateId,aParentId,strSeq,""))
		s objLocTem = ##Class(CF.EMR.DOC.LocTemplate).%OpenId(strRowID)
	    continue:(objLocTem="")
	    continue:(objLocTem.TempPublishVersion = "")
	    s objTem = objLocTem.TemplateID
	    s jsonTem  = ##class(%DynamicObject).%New()
	    s jsonTem.id = "LocTemplate-"_strRowID
	    s jsonTem.text = objLocTem.EMRName
	    s jsonTem.type = "LocTemplate"
	    s jsonTem.docCode = jsonRecord.docCode
	    s jsonTem.docName = jsonRecord.docName
	    s jsonTem.docCategoryCode = jsonRecord.docCategoryCode
	    s jsonTem.docCategoryName = jsonRecord.docCategoryName
	    s jsonTem.chartItemType = objTem.ChartItemType
	    s jsonTem.documentType = objTem.DocumentType.Code
	    s jsonTem.isLeadframe = $case(jsonRecord.isLeadframe,"":"0",:jsonRecord.isLeadframe) 
	    s jsonTem.serial = $case(jsonRecord.serial,"":"0",:jsonRecord.serial) 
	    s jsonTem.isMutex = $case(jsonRecord.isMutex,"":"0",:jsonRecord.isMutex) 
	    s jsonTem.templateID = aTemplateId
	    s:(objLocTem.Disease'="") jsonTem.disease = objLocTem.Disease.DiagnosCode_"-"_objLocTem.Disease.DiagnosName
	    s jsonTem.quotation = jsonRecord.quotation
	    s jsonTem.templateCategoryID = $case(aParentId,-100000000000000:"",:aParentId)
	    //记录目录ID串1^2^3
	    s jsonTem.pids=aPids
	    s jsonTem.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(objLocTem.EMRName,4,"")
	    s jsonTem.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(objLocTem.EMRName,3,"")
	    s jsonTem.iconCls = ""
	    s jsonTem.documentID = ""
	    s jsonTem.sourceID = strRowID
	    s jsonTem.sourceType = "LocTemplate"
	    s jsonTem.eventID = ""
	    s jsonTem.eventType = ""
	    s jsonTem.pluginType = "WORD"
		d jsonTemplate.%Push(jsonTem)	
	}
	q res
}

/// Desc:      判断模板是否适用于指定的病人
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Table:		CF.EMR.DOC.TemplateRules
/// Input:      aLocTemID 模板ID
/// 			aPatInfo--病人信息列表（如 科室、性别等）
/// OutPut:     1--适用  0--不适用
/// Debug: 		w ##class(EMR.OP.BL.LocTemplateRules).CanTempAct("1","")
ClassMethod CanTempAct(aLocTemID As %String, aPatInfo As %Library.List) As %Status
{
	q:(($d(aLocTemID)=0) || (aLocTemID = "")) 0
 	q:(($d(aPatInfo)=0) || (aPatInfo = "")) 0
	s privResult = 0
 	set ruleID = ""
 	for 
 	{
		set ruleID = $o(^CF.EMR.DOC.LocTemplateRulesI("TemplateIDIdx",aLocTemID,ruleID)) //注：此处取得的 groupID 在左侧含有空格
		q:(ruleID="")
		
		//遍历该模板组下的规则，校验是否有规则适合
		s tempPrivResult = ..CheckPriv(ruleID, aPatInfo)
		if (tempPrivResult =  1)
		{
			s privResult = 1
			q
		}
 	}
 	q privResult
}

/// Desc:      判断当前病人是否符合某一条规则（parRestrictionId指定的规则）
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Table:		CF.EMR.DOC.TemplateRules
/// Input:      pRuleId--规则的配置串(如 PATDEPT:129^PATTYPE:19);
/// 			aPatInfo--病人信息列表（如 科室、性别等）
/// OutPut:     1--适用  0--不适用
/// Debug:
ClassMethod CheckPriv(aRuleId As %String, aPatInfo As %Library.List) As %Status
{
	q:(($d(aRuleId)=0) || (aRuleId = "")) 0
 	q:(($d(aPatInfo)=0) || (aPatInfo = "")) 0
 	
 	//取出规则中的条件
 	s ruleCondition = $lg(^CF.EMR.DOC.LocTemplateRulesD(aRuleId), 3)
	q:(ruleCondition = "") 0
	
	s:(ruleCondition'["SSLAN") ruleCondition = ruleCondition_"^SSLAN:CH"
	
 	//根据规则的类型组合数据去判断权限的有效性
 	s privResult = 1
 	for i=1:1:$l(ruleCondition,"^")
 	{
		s strType = $p(ruleCondition,"^",i)
		q:(($d(strType)=0)||(strType = ""))
		s strTName = $p(strType,":",1)
		s strTValue = ..GetTypeValue(strTName,aPatInfo)
		///科室为空时，不做校验
		if (strTName="PATDEPT")
		{
			continue:(strTValue="")
		}
		s curType = strTName_":"_strTValue

		s:(curType '= strType) privResult=0
		q:(privResult = 0)
	}
	q privResult
}

/// Desc:      取出病人某一个单项的数据
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Table:		CF.EMR.DOC.TemplateRules
/// Input:      aType--规则单项的类型(如 PATDEPT)
/// 			aPatInfo--病人信息列表（如 科室、性别等）
/// OutPut:     1--适用  0--不适用
/// Debug:
ClassMethod GetTypeValue(aType As %String, aPatInfo As %Library.List) As %String
{
	q:(($d(aType)=0) || (aType = "")) ""
	
	s data = ""
	
	for j=1:1:$ll(aPatInfo) 
	{
		s PIItem=$li(aPatInfo,j)
		if ($p(PIItem,$c(2),1)=aType) 
		{
			s data=$p(PIItem,$c(2),2)
			quit
		}
	}
	q data
}

}
