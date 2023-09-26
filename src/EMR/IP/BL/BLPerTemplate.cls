/// 名称:	EMR.IP.BL.BLPerTemplate
/// 描述:	住院病历 文档实例业务逻辑类
/// 编写者：lifengbo
/// 编写日期: 2023-03-21
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLPerTemplate Extends EMR.IP.COM.ActionBase
{

/// Desc:       保存实例备注信息
/// Creator:    lifengbo
/// CreateDate: 2023-03-21
/// Table:		
/// Input:      argArray  命令参数 {"action":"CREATE_DOCUMENT","params":{"templateId":"68","episodeId":"660","userCode":"10209","ip":"192.168.101.37","patientId":"27","loadMode":"baseTem","userLocId":"6","happenDateTime":"","title":"","titleCode":"","userTemplateCode":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetUserTemplateCTLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s documentID="", memoText=""
	
	s userID=argInJson.params.userID
	s userLocID=argInJson.params.userLocID
	s episodeID=argInJson.params.episodeID
	s docCategoryCode=argInJson.params.docCategoryCode
	s text=argInJson.params.text
	
    s strRes = ##Class(EMR.IP.BL.BLPerTemplate).GetUserTemplateCTLocJson(docCategoryCode,text,episodeID,userID,userLocID,.argOutData)
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

/// /////////////////////////////////
/// JSON 组合代码
/// ////////////////////////////////
/// Desc:	获取病历实例备注信息
/// Input:	
/// Return:	设置状态
/// Debug:	w ##Class(EMR.IP.BL.BLPerTemplate).GetUserTemplateCTLocJson(285)
ClassMethod GetUserTemplateCTLocJson(argCategoryIDs As %String, argText As %String = "", argEpisodeID As %String, argUserID As %String, argLocID As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "-100"
	
	s jsonArr = []
	q:((argCategoryIDs = "")||(argEpisodeID="")||(argUserID="")) json
	
	s arryCtLocID = ##Class(%ArrayOfDataTypes).%New()

	s jsonSubAll = {}
	s jsonSubAll.RowID = "ALL"
	s jsonSubAll.Code = "ALL"
	s jsonSubAll.Desc = "全院"
	d jsonArr.%Push(jsonSubAll)


	s strCIDCount = $l(argCategoryIDs,",")
	
	s flag = 0
	s admCTLOC="",admCTLOCID=""
	s admCTLOC = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisDept(argEpisodeID,"","")
	s:(admCTLOC'="") admCTLOCID = $P(admCTLOC,"^",1)
	s admHospitalID = $p($g(^CTLOC(admCTLOCID)),"^",22)
	
	
	for j=1:1:strCIDCount
	{
		s categoryID = $p(ACategoryIDs,",",j)
		//先根据目录ID获取docID集合
		s pDocIDs = ##Class(EMRservice.BL.BLClientCategory).GetTempDocIdsByCategoryID(categoryID,argEpisodeID,pUserID)
		s docIDCount = $l(pDocIDs,"^")
		for i=1:1:docIDCount
		{
			s pDocID = $p(pDocIDs,"^",i)
			s templateId = ""
			for
			{
				s templateId = $o(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_pDocID,templateId))
				q:(templateId = "")
				s code = ""
				for
				{
					s code = $o(^DHCEMRM.UserTemplateI("IdxTemplateCode",templateId,code))	
					q:(code = "")
					s userRowId =$o(^DHCEMRM.UserTemplateI("IdxTemplateCode",templateId,code,""))
					continue:(userRowId = "")
					s objUserTempalte = ##Class(EMRmeta.UserTemplate).%OpenId(userRowId)
					continue:((objUserTempalte="")||(objUserTempalte.Status '=1))
					s ctLocId = ""
					for
					{
						s ctLocId = $o(^DHCEMRM.UserTemplateCTLocI("IdxCodeAndCTLocID",code,ctLocId))
						q:(ctLocId = "")
						s rowId =  $zstrip(ctLocId,"*P")
						
						s HospitalID = $p($g(^CTLOC(rowId)),"^",22)
						continue:(HospitalID'=admHospitalID)
						
						s locCode = $p($g(^CTLOC(rowId)),"^",1)
						s locDesc = $p($g(^CTLOC(rowId)),"^",2)
						
						continue:((pText '= "")&&($zcvt(locDesc,"U")'[ $zcvt(pText,"U")))
						continue:(arryCtLocID.GetAt(rowId) '= "")
						d arryCtLocID.SetAt(code,rowId)

						d json.Write("{")
						d json.Write("""RowID"":"""_rowId_"""")
						d json.Write(",""Code"":"""_locCode_"""")
						d json.Write(",""Desc"":"""_locDesc_"""")
						d json.Write("}")
						s:(rowId=argLocID) flag=1	
					}
				 }
			}
		}	
	}
	
	if (flag=0)&&(argLocID'="")
	{
		s curCode = $p($g(^CTLOC(argLocID)),"^",1)
		s curDesc = $p($g(^CTLOC(argLocID)),"^",2)
		s jsonsub = {}
		s jsonsub.RowID= argLocID
		s jsonsub.Code= curCode
		s jsonsub.Desc= curDesc
		d jsonArr.%Push(jsonsub)
	}
	d json.Write("]")

	
	d jsonArr.%ToJSON(argOutData)
	q 1
Error
	s $zt =""
    q "-1^"_$zerror
}

/// Desc:       根据模板目录信息组合为二位数组(主键父ID，值为第一层子节点ID数组)
/// Creator:    yejian
/// CreateDate: 2021-7-30(lifengbo)
/// Input:      jsonTem 模板json对象
/// 			arrData 需要构建的JSON数据
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.IP.BL.BLPerTemplate).GetJsonDataByTemJson("",.argOutData)
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
/// Creator:	yejian(lifengbo)
/// CreateDate:	2021-8-11
/// Input:      jsonData 文档json数据
///             argOutData 转换后的流数据
/// Output:    	成功1、失败-1
/// Debug: 		d ##class(EMR.IP.BL.BLPerTemplate).GetJsonData(0,"","")
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
			s objCat = ##class(CF.EMR.DOC.PerTemplateCategory).%OpenId(strValue)
			continue:(objCat="")
			s jsonCat = ##class(%DynamicObject).%New()
			s jsonCat.id="flod-"_strValue
			s jsonCat.type="flod"
			s jsonCat.text=objCat.Name
			s jsonCat.state="closed"
			s jsonCat.pid=strValue
			s jsonCat.icon=""
			d jsonArr.%Push(jsonCat)			
			d ##class(EMR.DOC.BL.PerTemplate).GetJsonData(strValue,arrData,.jsonCat)
		}
	}
	s ajsonP.children =jsonArr
	q result
}

}
