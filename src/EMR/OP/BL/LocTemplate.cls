/// 名称:	EMR.OP.BL.LocTemplate
/// 描述:	门诊病历 科室模板业务类
/// 编写者：yejian
/// 编写日期: 2022-6-27
/// 产品组：电子病历产品组
Class EMR.OP.BL.LocTemplate Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取科室模板数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aTemplateId 模板ID
/// 	        aParentId 目录ID
///             aProductid 项目标识
///             aPids 目录id串1^2^3
/// Output:     q ##Class(EMR.OP.BL.LocTemplate).GetJsonLocTempalteByCID(0,1,1,)
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

/// Desc:       根据模板目录信息组合为二位数组(主键父ID，值为第一层子节点ID数组)
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      jsonTem 模板json对象
/// 			arrData 需要构建的JSON数据
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.LocTemplate).GetJsonDataByIds("YS01","TEMPLATE",.argOutData)
ClassMethod GetJsonDataByTemJosn(jsonTem As %DynamicAbstractObject, ByRef arrGroup As %ArrayOfDataTypes) As %String
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

/// Debug: 		d ##class(EMR.OP.BL.LocTemplate).Test()
ClassMethod Test()
{
	s strArr = [{"pids":"47^260^270","temid":"T201"},{"pids":"47^260^271","temid":"T136"},{"pids":"47^260^271","temid":"T199"},{"pids":"47^261^275","temid":"T202"},{"pids":"47^261^276","temid":"T200"},{"pids":"47^319","temid":"T32"},{"pids":"47^319","temid":"T99"},{"pids":"47^319","temid":"T133"},{"pids":"47^319","temid":"T134"},{"pids":"47^319","temid":"T135"},{"pids":"47^319","temid":"T139"},{"pids":"47^319","temid":"T145"},{"pids":"47^319","temid":"T146"},{"pids":"47^319","temid":"T147"},{"pids":"47^319","temid":"T148"},{"pids":"47^319","temid":"T149"},{"pids":"47^319","temid":"T150"},{"pids":"48^316","temid":"T137"},{"pids":"48^317","temid":"T118"},{"pids":"48^318","temid":"T33"},{"pids":"48^318","temid":"T127"},{"pids":"48^318","temid":"T144"},{"pids":"52^320","temid":"T37"},{"pids":"52^320","temid":"T96"},{"pids":"52^320","temid":"T98"},{"pids":"52^320","temid":"T121"},{"pids":"52^320","temid":"T130"},{"pids":"52^320","temid":"T131"},{"pids":"","temid":"T1311"}]
	s arrData = ##class(%ArrayOfDataTypes).%New()
	set iter = strArr.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s jsonTem = item
        continue:(item="")
        s arrTemIds = ##class(EMR.OP.BL.LocTemplate).GetJsonDataByTemJosn(item,.arrData)
	}
	s jsonData = ##class(%DynamicObject).%New()
	s strRes = ##class(EMR.OP.BL.LocTemplate).GetJsonData("0",arrData,.jsonData)
	w jsonData.children.%ToJSON()
}

}
