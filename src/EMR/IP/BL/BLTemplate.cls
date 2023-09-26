/// 名称:	EMR.IP.BL.BLTemplate
/// 描述:	门诊病历 文档业务类
/// 编写者：yejian(lifengbo)
/// 编写日期: 2021-7-27
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLTemplate Extends EMR.IP.COM.ActionBase
{

/// Desc:       获取模板数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProductid 项目标识
///             aPids 目录id串1^2^3
/// Output:     q ##Class(EMR.IP.BL.BLTemplate).GetJsonTempalteByCID(0,1,1,)
ClassMethod GetJsonTempalteByCID(aParentId As %String, jsonRecord As %DynamicAbstractObject, ByRef aPids As %String, ByRef jsonTemplate As %DynamicAbstractObject) As %String
{
	s res = "1"
	s strSeq = ""
	for {
		s strSeq = $o(^CF.EMR.DOC.TemplateI("IdxCatSeq",aParentId,strSeq))
		q:(strSeq = "")			
		s strRowID = $o(^CF.EMR.DOC.TemplateI("IdxCatSeq",aParentId,strSeq,""))
		s objTem = ##Class(CF.EMR.DOC.Template).%OpenId(strRowID)
	    continue:(objTem="")
	    continue:(objTem.TempPublishVersion = "")
	    s jsonTem  = ##class(%DynamicObject).%New()
	    s jsonTem.id = "Template-"_strRowID
	    s jsonTem.text = objTem.EMRName
	    s jsonTem.type = "Template"
	    s jsonTem.docCode = jsonRecord.Code
	    s jsonTem.docName = jsonRecord.text
	    s jsonTem.docCategoryCode = jsonRecord.docCategoryCode
	    s jsonTem.chartItemType = objTem.ChartItemType
	    s jsonTem.documentType = objTem.DocumentType.Code
	    s jsonTem.isLeadframe = $case(jsonRecord.isLeadframe,"":"0",:jsonRecord.isLeadframe) 
	    s jsonTem.serial = $case(jsonRecord.serial,"":"0",:jsonRecord.serial) 
	    s jsonTem.isMutex = $case(jsonRecord.isMutex,"":"0",:jsonRecord.isMutex) 
	    s jsonTem.templateID = strRowID
	    s jsonTem.quotation = jsonRecord.quotation
	    s jsonTem.templateCategoryID = aParentId
	    s jsonTem.docCategoryName = jsonRecord.docCategoryName
	    //记录目录ID串1^2^3
	    s jsonTem.pids=aPids
	    s jsonTem.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(objTem.EMRName,4,"")
	    s jsonTem.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(objTem.EMRName,3,"")
	    s jsonTem.iconCls = ""
	    s jsonTem.documentID = ""
	    s jsonTem.sourceID = strRowID
	    s jsonTem.sourceType = "Template"
	    s jsonTem.eventID = ""
	    s jsonTem.eventType = ""
	    s jsonTem.pluginType = "WORD"
		d jsonTemplate.%Push(jsonTem)	
	}
	q res
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
///             w ##class(EMR.OP.BL.Template).GetJsonDataByIds("YS01","TEMPLATE",.argOutData)
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
/// Creator:	yejian 
/// CreateDate:	2021-8-11
/// Input:      jsonData 文档json数据
///             argOutData 转换后的流数据
/// Output:    	成功1、失败-1
/// Debug: 		d ##class(EMR.IP.BL.BLTemplate).GetJsonData(0,"","")
ClassMethod GetJsonData(aKey As %String, arrData As %ArrayOfDataTypes, ByRef ajsonData As %DynamicArray) As %String
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
			d ajsonData.%Push(strValue)
		}
		else //数字为目录
		{			
			d ##class(EMR.IP.BL.BLTemplate).GetJsonData(strValue,arrData,.ajsonData)
		}
	}
	q result
}

/// Desc:       根据文档ID获取病历所用的模板数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.DOC.Template 模板表，EMR_DB.DocumentData 实例表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_TEMPLATEDATABYDOCUMENTID","params":{"documentIDs":["47"]}}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTemplateDataByDocumentID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s documentIds = argInJson.params.documentIDs
    s strRes = ##Class(EMR.IP.BL.BLTemplate).GetTemplateDataByDocumentIDJson(documentIds,.argOutData)
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
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       根据文档ID获取病历所用的模板数据
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      aDocumentIds 文档ID集合
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.DocumentData).LoadDocumentJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetTemplateDataByDocumentIDJson(aDocumentIds As %DynamicArray, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "OPError"
	s strRes = "1",documentID=""
	q:((aDocumentIds="")||(aDocumentIds.%Size()=0)) "-1^实例ID不能为空"
	s jsonArr = ##class(%DynamicObject).%New()
	set iter = aDocumentIds.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s documentID = item
        continue:(documentID = "")

		s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
		if (objDocument ="")||(objDocument.TemplateID="")
		{
			s strRes ="-1^"_documentID_"获取实例失败"	
			q
		}
		s objTem = objDocument.TemplateID
	    continue:(objTem="")
	    continue:(objTem.TempPublishVersion = "")
	   	s templateID = objTem.%Id()
	    s strTemCId = ##Class(EMR.OP.BL.TemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
		continue:(strTemCId="")
		s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)
		s objDocCTem = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objTemCat.ParentID)
	    s jsonTem  = ##class(%DynamicObject).%New()
	    s jsonTem.id = "Template-"_templateID
	    s jsonTem.text = objTem.EMRName
	    s jsonTem.type = "Template"
	    s jsonTem.docCode = objTemCat.Code
	    s jsonTem.docName = objTemCat.EMRName
	    s jsonTem.docCategoryCode = objDocCTem.Code
	    s jsonTem.chartItemType = objTem.ChartItemType
	    s jsonTem.documentType = objTem.DocumentType.Code
	   	s jsonTem.isLeadframe =$case(objTemCat.Title.IsLeadframe,"":"0",:objTemCat.Title.IsLeadframe)
	    s jsonTem.serial = $case(objTemCat.Title.Serial,"":"0",:objTemCat.Title.Serial)
	    s jsonTem.isMutex = $case(objTemCat.Title.IsMutex,"":"0",:objTemCat.Title.Serial)
	    s jsonTem.templateID = templateID
	    s jsonTem.quotation = "0" //##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,docId) 
	    s jsonTem.templateCategoryID = objTem.TemplateCategory.%Id()
	    s jsonTem.docCategoryName = objDocCTem.EMRName
	    //记录目录ID串1^2^3
	    s jsonTem.pids=""
	    s jsonTem.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(objTem.EMRName,4,"")
	    s jsonTem.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(objTem.EMRName,3,"")
	    s jsonTem.iconCls = ""
	    s jsonTem.documentID = documentID
	    s jsonTem.sourceID = templateID
	    s jsonTem.sourceType = "Template"
	    s jsonTem.eventID = ""
	    s jsonTem.eventType = ""
		d jsonArr.%Set(documentID,jsonTem)
		d objDocument.%Close()
		k objDocument
	}
	d:(jsonArr.%Size()>0) jsonArr.%ToJSON(argOutData)
	q strRes
OPError
    q "-1^"_documentID_","_$zerror
}

}
