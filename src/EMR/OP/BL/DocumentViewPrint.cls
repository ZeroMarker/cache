/// 名称:	EMR.OP.COM.ActionBase
/// 描述:	门诊病历-自助打印(基类)
/// 编写者：yejian
/// 编写日期: 2022-12-7
/// 产品组：电子病历产品组
Class EMR.OP.BL.DocumentViewPrint Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取当前患者预览病历ID
/// Creator:    yejian
/// CreateDate: 2022-7-18
/// Table:		病历导航相关表，实例表
/// Input:      argInJson  命令参数 {"product":"OP","action":"LOAD_DOCUMENT_BYEPISODEID","params":{"episodeID":"713","ssgroupID":"28","order":"-1","userLocID":"6","status":"Sign"}}
/// 								userLocID:科室ID
/// 								ssgroupID:安全组ID
///             					episodeID:就诊号
/// 								userID:用户ID
/// 								DOCCategoryCode:业务活动记录分类编码
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadDocumentBYEpisodeID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.OP.DTO.DocCategory).%New()
	s dtoItem.ProductCode = argInJson.product
	s dtoItem.CTLocID = argInJson.params.userLocID
	s dtoItem.SSGroupID = argInJson.params.ssgroupID
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s dtoItem.Status = argInJson.params.status
	s dtoItem.Order = $case(argInJson.params.order,"1":"",:argInJson.params.order)
	s dtoItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.DocumentViewPrint).LoadDocumentBYEpisodeIDJson(dtoItem,.argOutData)
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

/// Desc:       获取当前患者已保存的病历
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 默认模板入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.DocumentViewPrint).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod LoadDocumentBYEpisodeIDJson(dtoItem As EMR.OP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(dtoItem.CTLocID="") "-1^科室ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.SSGroupID="") "-1^安全组ID不能为空"
	s resJson = ##class(%DynamicObject).%New()
	s valueJson = ##class(%DynamicArray).%New()
	s idsJson = ##class(%DynamicArray).%New()
	s TILDocument = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(dtoItem.EpisodeID)
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d result.Execute(dtoItem.CTLocID, dtoItem.SSGroupID, dtoItem.EpisodeID,dtoItem.LangID)
	while result.%Next()
	{
		s strDocCID = result.Data("ID")
		s strDOCCategoryCode = result.Data("DOCCategoryCode")
		s valueArrJson = ##class(%DynamicArray).%New()
		//设置业务活动记录分类ID，以及分类编码
		s dtoItem.ParentID = strDocCID
		s strDOCCategoryCode =$zcvt(strDOCCategoryCode,"U")
		s hasListNo = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, ""))
		continue:(""=hasListNo)
		s listNo = ""
		for
		{
			if (dtoItem.Order="-1")
			{
				s listNo = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, listNo),dtoItem.Order)
			}
			else
			{
				s listNo = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, listNo))
			}
			q:(listNo="")
			s docID = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, listNo,""))
			s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(docID)
			continue:(objDocument="")
			//删除状态排除
			continue:("Save" '= objDocument.Status)
			s objTem = objDocument.TemplateID
			continue:(objTem="")
			s strTemCId = ##Class(EMR.OP.BL.TemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
			continue:(strTemCId="")
			s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)
			s hasSign = ##Class(EMR.DOC.BL.DocLog).HasRecordSign(dtoItem.EpisodeID,docID)
			//如果签名状态，获取已签名的文档
			continue:(($zcvt(dtoItem.Status,"U")="SIGN")&&(hasSign'=1))
			
			//数据解压缩
			s objStream = ##Class(%GlobalBinaryStream).%New()
			s temStream = ##class(EMR.DOC.COM.Parser.StreamData).DeCompressStream(objDocument.DocumentStream.DocumentData)
			d temStream.Rewind()
			while (temStream.AtEnd = 0)
			{
				s tmpOut = temStream.Read(30000)
				s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
				d objStream.Write(tmpUtf8)
		  	} 
			s docJson = ##class(%DynamicAbstractObject).%FromJSON(objStream)
			
			//如果是连续加载文档，只需要JSON数组增加一个实例ID
			if (("MULTIPLE"=objTem.ChartItemType) && ("1"=objTemCat.Title.IsLeadframe))
			{
				d valueArrJson.%Push(docJson)
				d idsJson.%Push(docID)
			}
			else
			{
				d valueJson.%Push(docJson)
				d idsJson.%Push(docID)
			}
		}
		d:(valueArrJson.%Size()>0) valueJson.%Push(valueArrJson)
	}
    //s resJson.value = valueJson
    //s resJson.documentIDs = idsJson
    s resJson.documentData = valueJson
    s resJson.documentID = idsJson
	d:(idsJson.%Size()>0) resJson.%ToJSON(argOutData)
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc   : 病历总览打印,获取指定就诊所有保存状态的病历接口(BS版)
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// input  : AEpisodeID 就诊号ID
/// output : json
///          InstanceId：病历实例ID，Text：病历实例的名称
/// Debug:   w ##class(EMR.OP.BL.DocumentViewPrint).GetSavedDocumentByEpisodeID("2161")
ClassMethod GetSavedDocumentByEpisodeID(AEpisodeID As %String) As %String
{
    s json = "",cateTem="",CategoryName=""
    q:(AEpisodeID="") json
    //判断新版全局图表是否包含就诊，如果包含走四版接口
    s TILDocument = ##Class(EMR.DAO.DocumentData).GetTureIndexLocation(AEpisodeID)
    s strDOCCategoryCode = ""
    for
	{
		s strDOCCategoryCode = $O(@TILDocument@("IdxMain",AEpisodeID,strDOCCategoryCode))
		q:(strDOCCategoryCode="")
		s listNo=""
		for
		{
			s listNo = $O(@TILDocument@("IdxMain",AEpisodeID,strDOCCategoryCode, listNo))
			q:(listNo="")
			s docID = $O(@TILDocument@("IdxMain",AEpisodeID,strDOCCategoryCode, listNo,""))
			s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(docID)
			continue:(objDocument="")
			//删除状态排除
			continue:("Save" '= objDocument.Status)
			s objTem = objDocument.TemplateID
			continue:(objTem="")
			s catRID= ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
			s recordTem= ##class(CF.EMR.DOC.TemplateCategory).%OpenId(catRID)
			s:(recordTem'="") cateTem = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(recordTem.ParentID)
			s:(cateTem'="") CategoryName = cateTem.EMRName
			//1,有效签名 0,未签名 或签名无效 
			s isSigned = ##Class(EMR.DOC.BL.DocLog).HasRecordSign(AEpisodeID,docID)
            s:(json'="") json = json_","
            s json = json_"{""InstanceId"":"""_docID_""","
            s json = json_"""Text"":"""_objDocument.DOCName_""","
            s json = json_"""CategoryName"":"""_CategoryName_""","
			s json = json_"""IsSigned"":"""_isSigned_"""}"
		}
	}
	q "["_json_"]"
}

/// Desc   : 病历总览打印,判断本次就诊所书写门诊病历的打印状态(BS版)
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// input  : AEpisodeID 就诊号ID
/// Output:   ret格式：{episodeId:"",hasNoPrinted:"1","documents":[{"instanceId":"1||1","isprinted":"1"},{"instanceId":"2||1","isprinted":"0"},……]}
/// Debug:    w ##Class(EMR.OP.BL.DocumentViewPrint).GetDocumentPrintedStatus("2167") 
ClassMethod GetDocumentPrintedStatus(AEpisodeID As %String) As %String
{
	s ret = "",item = "",isprinted="",unPrintedCount=""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	 s TILDocument = ##Class(EMR.DAO.DocumentData).GetTureIndexLocation(AEpisodeID)
	s unPrintedCount = 0
	 s strDOCCategoryCode = ""
    for
	{
		s strDOCCategoryCode = $O(@TILDocument@("IdxMain",AEpisodeID,strDOCCategoryCode))
		q:(strDOCCategoryCode="")
		s listNo=""
		for
		{
			s listNo = $O(@TILDocument@("IdxMain",AEpisodeID,strDOCCategoryCode, listNo))
			q:(listNo="")
			s docID = $O(@TILDocument@("IdxMain",AEpisodeID,strDOCCategoryCode, listNo,""))
			s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(docID)
			continue:(objDocument="")
			continue:(objDocument.Status '= "Save")
			//是否过滤无有效签名或无签名病历
			s signFlag = ##Class(EMR.DOC.BL.DocLog).HasRecordSign(AEpisodeID,docID)
			continue:(signFlag = 0)
		    s log = ##Class(EMR.DOC.BL.DocLog).GetLogStatus(AEpisodeID,docID)
		    //获取病历日志明细最后一次操作的Action名字
			s action = log.action
			s:(action '= "print") action = ""
			if (action '= "") {
				s isprinted = "1"
			}else {
				s unPrintedCount = unPrintedCount + 1
			}
		    s:(item '= "") item = item_","
			d OutPutToJson
		}
	}
	if (item = "") {
		s ret = "{""episodeId"":"""_AEpisodeID_""",""hasNoPrinted"":0}"
	}else {
		s ret = "{""episodeId"":"""_AEpisodeID_""",""hasNoPrinted"":"_unPrintedCount
		s ret = ret_",""documents"":["_item_"]"
		s ret = ret_"}"
	}
	q ret
OutPutToJson
    s item = item_"{""instanceId"":"""_docID
    s item = item_""",""isprinted"":"""_isprinted_"""}"
    q
}

}
