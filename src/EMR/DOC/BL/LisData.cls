/// 名称:	EMR.OP.BL.PacsData
/// 描述:	门急诊检验结果功能相关业务
/// 编写者:	yejian
/// 编写日期:2022-10-12
/// 产品组:	电子病历产品组
Class EMR.DOC.BL.LisData Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取检验主数据
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_LISDATA","params":{"interface":"HSBToHis","episodeIDs":"285","startDateTime":"","endDateTime":"","authStartDateTime":"","authEndDateTime":"","patientID":"","authorizedFlag":"1","dateGap":"","page":1,"rows":20},"product":"OP"}
/// 			interface: 调用接口标识(默认HIS) ,episodeIDs:就诊号以","分隔,startDateTime:开始时间,endDateTime:结束时间,authStartDateTime:报告审核开始时间,	
///             authEndDateTime:报告审核结束时间,AuthorizedFlag:审核标识,patientID:病人PatientID,dateGap:就诊日期间隔,例如90天,page:当前页
///             rows:每页行数		
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetLisData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	;s argInJson = {"action":"GET_LISDATA","params":{"interface":"HIS","episodeIDs":"285","startDateTime":"","endDateTime":"","authStartDateTime":"","authEndDateTime":"","patientID":"","authorizedFlag":"1","dateGap":"","page":"1","rows":"10"},"product":"OP"}
	s dtoItem = ##class(EMR.DOC.DTO.LisData).%New()
	s dtoItem.Product=argInJson.product
	s interface=argInJson.params.interface
    s dtoItem.InterFace = $CASE(interface,"":"HIS",:interface)
    s dtoItem.EpisodeIDs=argInJson.params.episodeIDs
    s dtoItem.PatientID=argInJson.params.patientID
    s dtoItem.StDate=argInJson.params.startDateTime
    s dtoItem.EndDate=argInJson.params.endDateTime
    s dtoItem.AuthStDate=argInJson.params.authStartDateTime
    s dtoItem.AuthEndDate=argInJson.params.authEndDateTime
    s dtoItem.AuthorizedFlag=argInJson.params.authorizedFlag
    s aEpisodeID = $p(dtoItem.EpisodeIDs,",",1)
    s admType = ""
    s:(aEpisodeID '= "") admType = $p($g(^PAADM(aEpisodeID)),"^",2)
    s dtoItem.AdmType = admType
    s page = argInJson.params.page  
    s rows=argInJson.params.rows
    s:(page'="") dtoItem.StartPage = rows * (page -1) + 1
	s:(page'="") dtoItem.EndPage = dtoItem.StartPage + rows -1
	s dtoItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.LisData).GetLisDataJson(dtoItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	;q argOutMessage.success = ..#OK
	  	//showtype -1 不输出外层信息，只输出argOutData
	  	q ..SetOutMessage(argOutMessage,"","",-1)
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

/// Desc:       获取检验主数据
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aItem 检验对象
/// OutPut:    	argOutData    返回数据
/// 		    EpisodeDate:就诊日期,DeptDesc:就诊科室,OEordItemRowID:医嘱ID,OEordItemDesc:医嘱名称,LabEpisodeNo:标本号,
///             SpecimenDesc:标本类型,CollectionDate:标本采集日期,CollectionTime:标本采集时间,ReceiveDate:标本接收日期,
///             ReceiveTime:标本接收时间,AuthorisationDate:标本审核日期,AuthorisationTime:标本审核时间,
///             ExistReport:是否有报告(Y:存在，N:不存在)
/// OutPut:     检验子项json
/// debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			w ##Class(EMR.DOC.BL.LisData).GetPacsDataJson("HIS",4,"2014-02-02","2014-08-15","","","",1,10,.argOutData)
ClassMethod GetLisDataJson(aItem As EMR.DOC.DTO.LisData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = ""
	s json = ""
	s jsonRes ={"total":0,"rows":[]}
	s TotalCount = 0
	s count = 0
	s:(aItem.AuthorizedFlag =2) aItem.EpisodeIDs = ##Class(EMR.DOC.HISInterface.EpisodeInfo).GetEpisodeIdsByPatientId(aItem.PatientID,aItem.AuthorizedFlag,"",aItem.Product,aItem.LangID)
	s:(aItem.AdmType = "O")&&(aItem.DateGap '= "") aItem.EpisodeIDs = ##Class(EMR.DOC.HISInterface.EpisodeInfo).GetEpisodeIdsByPatientId(aItem.PatientID,"",aItem.DateGap,aItem.Product,aItem.LangID)
	if (aItem.EpisodeIDs = "")
	{
		d jsonRes.%ToJSON(argOutData)
		q "1"
	}
	s key = $i(^CacheTemp)
	k ^TempEMRLisData(key)
	///报告时间查询条件的格式转换
	s:(aItem.AuthStDate'="") aItem.AuthStDate = $zdh(aItem.AuthStDate,3)
	s:(aItem.AuthEndDate'="") aItem.AuthEndDate= $zdh(aItem.AuthEndDate,3)
	s length = $l(aItem.EpisodeIDs,",")
	for I=1:1:length
	{
		s episodeId = $p(aItem.EpisodeIDs,",",I)
		s IsPreInPatient = $p($g(^PAADM(episodeId,"DHC")),"^",56)
		if (IsPreInPatient = "Y")
		{
			s tmpStDate = $Case(aItem.StDate,"":$p($g(^PAADM(episodeId)),"^",34),:$zdh(aItem.StDate,3))
			s tmpEndDate = $p($h,",",1)
		}
		else
		{
			s tmpStDate = $Case(aItem.StDate,"":$p($g(^PAADM(episodeId)),"^",6),:$zdh(aItem.StDate,3))
			s episodeType= $p(^PAADM(episodeId),"^",2)
			//检查的开始时间取建住院证的时间，南大二附院个性化修改
			/*
			s stDateType = ##Class(EMRservice.SystemParameter).GetResourceStartDate()
			if ((stDateType = "Y")&&(episodeType = "I"))
			{
				s patientId = $p($g(^PAADM(episodeId)),"^",1)
				s bookId = $o(^DHCDocIPBK(0,"PatientID",patientId,""))
				s bookStDate = $p($g(^DHCDocIPBK(bookId)),"^",10)
				s tmpStDate = bookStDate
			}*/
			s tmpEndDate = $Case(aItem.EndDate,"":$P($G(^PAADM(episodeId)),"^",17),:$zdh(aItem.EndDate,3))
		}
		s:(tmpEndDate = "") tmpEndDate = $p($h,",",1)
		s episodeDate = $ZD($p($g(^PAADM(episodeId)),"^",6),3)	 	
		s deptId = $p(^PAADM(episodeId),"^",4)
		s deptDesc = $Case(deptId,"":"",:$p(^CTLOC(deptId),"^",2))
		s:($f(deptDesc,"-") '= 0) deptDesc = $p(deptDesc,"-",2)
		
		if (aItem.InterFace = "HIS")
		{
			s ds = ##class(EMR.DOC.HISInterface.LisDataSrv).SelectLISItemListByDate(episodeId,tmpStDate,tmpEndDate)
		}
		elseif (aItem.InterFace = "数据平台")
		{
			s ds = ##Class(%Library.strResSet).%New("EMR.DOC.HISInterface.LisDataSrv:GetLisDataList")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)		
		}
		elseif (aItem.InterFace = "HSBToHis")
		{
			s ds = ##class(EMR.DOC.HISInterface.LisDataSrv).SelectLISItemListData(episodeId,tmpStDate,tmpEndDate)
		}
		//elseif (aItem.InterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		
		///若报告时间查询条件为当天
		if (aItem.AuthStDate'="")&&(aItem.AuthStDate=aItem.AuthEndDate)
		{
			While (ds.Next())
			{
				continue:ds.Data("AuthorisationDate")=""
				continue:($zdh(ds.Data("AuthorisationDate"),3)'=aItem.AuthStDate)
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		///若报告时间查询条件为三天或一周
		elseif(aItem.AuthStDate'="")&&(aItem.AuthStDate'=aItem.AuthEndDate)
		{
			While (ds.Next())
			{
				continue:ds.Data("AuthorisationDate")=""
				continue:'(($zdh(ds.Data("AuthorisationDate"),3)>=aItem.AuthStDate)&&($zdh(ds.Data("AuthorisationDate"),3)<=aItem.AuthEndDate))
				s TotalCount = TotalCount + 1 
				d setJson
			 }
		}
		///若报告时间查询条件为本次就诊
		elseif(aItem.AuthorizedFlag =1)
		{
			While (ds.Next())
			{
				continue:'(ds.Data("AuthorisationDate")'="")
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		elseif(aItem.AuthorizedFlag =0)
		{
			///未报告
			While (ds.Next())
			{
				continue:'(ds.Data("AuthorisationDate")="")
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}else
		{
			///所有医嘱
			while (ds.Next())
			{
				 s TotalCount = TotalCount + 1 
				 d setJson
			}
		}
	}
	
	//倒序排序输出
	s LisAuthDate="",j=0,i=1
	for
	{
		s LisAuthDate = $o(^TempEMRLisData(key,LisAuthDate),-1)
		q:(LisAuthDate="")
		s LisAuthTime=""
		for
		{
			s LisAuthTime = $o(^TempEMRLisData(key,LisAuthDate,LisAuthTime),-1)
			q:(LisAuthTime = "")
			s order = ""
			for {
				s order = $o(^TempEMRLisData(key,LisAuthDate,LisAuthTime,order))
				q:(order = "")
				if ((aItem.StartPage <= i)&(i <= aItem.EndPage))
				{
					s:(j'=0) strRes = strRes_","
					s strRes = strRes_^TempEMRLisData(key,LisAuthDate,LisAuthTime,order)
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
	k ^TempEMRLisData(key)
	s strRes = "{""total"":"_TotalCount_",""rows"":["_strRes_"]}"
	s strRes = $ZSTRIP(strRes,"*C")
	s jsonRes = ##class(%DynamicObject).%FromJSON(strRes)
	d jsonRes.%ToJSON(argOutData)
	q "1"
setJson
	s json = json_"{"
	s json = json_"""EpisodeDate"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",episodeDate)_""","
	s json = json_"""EpisodeID"":"""_episodeId_""","
	s json = json_"""DeptDesc"":"""_deptDesc_""","
	s json = json_"""OEordItemRowID"":"""_ds.Data("OEordItemRowID")_"""," 
	s json = json_"""OEordItemDesc"":"""_ds.Data("OEordItemDesc")_"""," 
	s json = json_"""LabEpisodeNo"":"""_ds.Data("LabEpisodeNo")_""","
	s json = json_"""SpecimenDesc"":"""_ds.Data("SpecimenDesc")_""","
	s json = json_"""strResStatus"":"""_$g(ds.Data("strResStatus"))_""","
	s json = json_"""CollectionDate"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("CollectionDate"))_""","
	s json = json_"""CollectionTime"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("CollectionTime"))_""","
	s json = json_"""ReceiveDate"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("ReceiveDate"))_""","
	s json = json_"""ReceiveTime"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("ReceiveTime"))_""","
	s json = json_"""AuthorisationDate"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("AuthorisationDate"))_""","
	s json = json_"""AuthorisationTime"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("AuthorisationTime"))_""","
	s:($g(ds.Data("ReportURL"))) json = json_"""ReportURL"":""<a href='"_ds.Data("ReportURL")_"' target='_balnk' style='scrollbars=0,resizable=0;width=300;'>影像报告</a>"","
	s json = json_"""ExistReport"":"""_ds.Data("ExistReport")_""","
	s LISRRTestConclusion = $g(ds.Data("LISRRTestConclusion"))
	s LISRRReportMark = $g(ds.Data("LISRRReportMark"))
	s json = json_"""LISRRTestConclusion"":"""_LISRRTestConclusion_""","
	s json = json_"""LISRRReportMark"":"""_LISRRReportMark_""""
	s json = json_"}"
	if (##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ds.Data("AuthorisationDate")) '= "")
	{
		s AuthDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ds.Data("AuthorisationDate"))
	}
	else
	{
		s AuthDate = "00000"
	}
	if (##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Time",ds.Data("AuthorisationTime")) '= "")
	{
		s AuthTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Time",ds.Data("AuthorisationTime"))
	}
	else
	{
		s AuthTime = "00000"
	}
	s ^TempEMRLisData(key,AuthDate,AuthTime,count) = json
	s json = ""
	s count = count + 1
	q
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

/// Desc:       获取检验子数据
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_SUBLISDATA","params":{"interface":"HIS","episodeIDs":"4","oeitemRowID":1,"labEpisodeNo":"1"},"product":"OP"}
/// 			interface: 调用接口标识(默认HIS) ,episodeIDs:就诊号以","分隔,oeitemRowID:医嘱ID
///             rows:每页行数		
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSubLisData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.LisData).%New()
	s dtoItem.Product=argInJson.product
	s interface=argInJson.params.interface
    s dtoItem.InterFace = $CASE(interface,"":"HIS",:interface)
    s dtoItem.EpisodeIDs=argInJson.params.episodeIDs
    s dtoItem.OEItemRowID = argInJson.params.oeitemRowID
    s dtoItem.LabEpisodeNo = argInJson.params.labEpisodeNo
	
    s strRes = ##Class(EMR.DOC.BL.LisData).GetSubLisDataJson(dtoItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	;q argOutMessage.success = ..#OK
	  	//showtype -1 不输出外层信息，只输出argOutData
	  	q ..SetOutMessage(argOutMessage,"","",-1)
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

/// Desc:       取检验子项
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aItem 检验对象
///             OEItemRowID 检验医嘱ID
/// OutPut:    	argOutData    返回数据
/// 			ExamDesc 检验所见,strstrRes 诊断意见,strOrderName 检验方法
/// debug:     	d ##Class(EMR.DOC.BL.LisData).GetSubPacsJson()
ClassMethod GetSubLisDataJson(aItem As EMR.DOC.DTO.LisData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s json = ""
	s count = 0
	s jsonRes = {"total":0,"rows":[]}
	if (aItem.OEItemRowID = "")
	{
		 d jsonRes.%ToJSON(argOutData)
		 q "1"
	}
	s key = $i(^CacheTemp)
	k ^TempEMRLisData(key)
	s OeordID = $p(aItem.OEItemRowID, "^", 1)
	s EpisodeID =  $p(aItem.EpisodeIDs, "^", 1)
	s LabEpisodeNo =  $p(aItem.LabEpisodeNo, "^", 1)	
	if (aItem.InterFace = "HIS")
	{
		s ds = ##class(EMR.DOC.HISInterface.LisDataSrv).SelectReportByOeordID(OeordID)
	}
	elseif (aItem.InterFace = "数据平台")
	{
		s ds = ##Class(%Library.strResSet).%New("EMR.DOC.HISInterface.PacsDataSrv:GetLisDataDetial")
		d ds.Execute(EpisodeID,"","",OeordID)	
	}
	elseif (aItem.InterFace = "HSBToHis")
	{
		s ds = ##class(EMR.DOC.HISInterface.LisDataSrv).SelectLISReportByOeordID(OeordID)
	}
	//elseif (aItem.InterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
	
	While (ds.Next())
	{
		s itemDesc = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(ds.Data("ItemDesc"))
		s ItemResult = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(ds.Data("ItemResult"))
		s abnorFlag=""
		if ((ds.Data("AbnorFlag")="高")||(ds.Data("AbnorFlag")="H"))
		{
			s abnorFlag="↑"
		}
		elseif ((ds.Data("AbnorFlag")="低")||(ds.Data("AbnorFlag")="L"))
		{
			s abnorFlag="↓"
		}
		elseif ((ds.Data("AbnorFlag")="A"))
		{
			s abnorFlag="A"
		}
		s itemUnit = ds.Data("ItemUnit")
		s itemUnitFw = $e(itemUnit,0,1)
		s itemUnit = $case(itemUnitFw,"*":"×","×":"×",:itemUnitFw)_$e(itemUnit,2,*)
		
		s detailData = "[]"
		if (aItem.InterFace = "数据平台")
		{
			s detailData = $g(ds.Data("DetailData"),"[]")
		}
		else
		{
			if (($g(ds.Data("strResDR")) '= ""))
			{
				s detailData = ##Class(EMR.DOC.BL.LisData).GetQryAntstrRes(ds.Data("strResDR"))
			}
		}
		
		s json = json_"{"
		s json = json_"""OeordID"":"""_OeordID_""","
		s json = json_"""LabEpisodeNo"":"""_LabEpisodeNo_""","
		s json = json_"""EpisodeID"":"""_EpisodeID_""","
		s json = json_"""ItemDesc"":"""_itemDesc_""","
		s json = json_"""Synonym"":"""_$case(ds.Data("Synonym"),"":itemDesc,:ds.Data("Synonym"))_""","  
		s json = json_"""ItemResult"":"""_ItemResult_"""," 
		s json = json_"""ItemUnit"":"""_itemUnit_"""," 
		s json = json_"""AbnorFlag"":"""_abnorFlag_"""," 
		s json = json_"""ItemRanges"":"""_ds.Data("ItemRanges")_"""," 
		s json = json_"""ReportDR"":"""_$g(ds.Data("strResDR"))_""","  
		s json = json_"""DetailData"":"_detailData_"" 
		s json = json_"}"
		s Sequence = $g(ds.Data("Sequence"))
		s:(Sequence = "") Sequence = 0
		s ^TempEMRLisData(key,Sequence,count) = json
		s json = ""
		s count = count + 1
	}
	s LisSequence="",j=0,strRes=""
	for
	{
		s LisSequence = $o(^TempEMRLisData(key,LisSequence))
		q:(LisSequence="")
		s order = ""
		for {
			s order = $o(^TempEMRLisData(key,LisSequence,order))
			q:(order = "")
			s:(j'=0) strRes = strRes_","
			s strRes = strRes_^TempEMRLisData(key,LisSequence,order)
			s j = j + 1
		}
	}
	k ^TempEMRLisData(key)
	s strRes = "{""total"":"_count_",""rows"":["_strRes_"]}"
	s strRes = $ZSTRIP(strRes,"*C")
	s jsonRes = ##class(%DynamicObject).%FromJSON(strRes)
	d jsonRes.%ToJSON(argOutData)
	q "1"
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

/// Desc:       取微生物药敏结果
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      ReportDR
/// Output:     json
/// ##Class(EMR.DOC.BL.LisData).GetQryAntstrRes("468")
ClassMethod GetQryAntstrRes(AReportDR As %String)
{
	s json = ""
	s count = 0
	q:(AReportDR = "") "{""total"":"_count_",""rows"":["_json_"]}"
	s ds = ##class(%strResSet).%New("LabService.TCstrRes:QryAntstrRes")
	d ds.Execute(AReportDR)
	s columCount = ds.GetColumnCount()
	while ds.%Next()
	{  
		s antName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape($g(ds.Data("AntName"))) 
		s senName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape($g(ds.Data("SenName"))) 
		s suggest = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape($g(ds.Data("Suggest"))) 
		s senMethod = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape($g(ds.Data("SenMethod")))
		s json = json_"{"
		s json = json_"""ReportDR"":"""_AReportDR_""","
		s json = json_"""AntCode"":"""_$g(ds.Data("AntCode"))_""","
		s json = json_"""AntName"":"""_antName_""","
		s json = json_"""LowRange"":"""_$g(ds.Data("LowRange"))_""","
		s json = json_"""SenCode"":"""_$g(ds.Data("SenCode"))_""","
		s json = json_"""SenName"":"""_senName_""","
		s json = json_"""Suggest"":"""_suggest_""","
		s json = json_"""SenMethod"":"""_senMethod_""""  
		s json = json_"}"
		s json = json_","
		s count = count + 1
	}
	s json = $e(json,1,$l(json)-1)
	s json = $ZSTRIP(json,"*C")
	q "["_json_"]"
}

/// Desc:       获取多个检验子数据
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_MULSUBPACSDATA","params":{"interface":"HIS","episodeIDs":"4","oeitemRowID":"3||71"},"product":"OP"}
/// 			interface: 调用接口标识(默认HIS) ,episodeIDs:就诊号以","分隔,oeitemRowID:医嘱ID以"^"分隔
///             rows:每页行数		
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetMultiSubLis(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.LisData).%New()
	s dtoItem.Product=argInJson.product
	s interface=argInJson.params.interface
    s dtoItem.InterFace = $CASE(interface,"":"HIS",:interface)
    s dtoItem.EpisodeIDs=argInJson.params.episodeIDs
    s dtoItem.OEItemRowID = argInJson.params.oeitemRowID
	s dtoItem.LabEpisodeNo = argInJson.params.labEpisodeNo
    s strRes = ##Class(EMR.DOC.BL.LisData).GetMultiSubLisJson(dtoItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	;q argOutMessage.success = ..#OK
	  	//showtype -1 不输出外层信息，只输出argOutData
	  	q ..SetOutMessage(argOutMessage,"","",-1)
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

/// Desc:       取多个检验子项
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aItem 检验对象
///             OEItemRowID 检验医嘱ID
/// OutPut:    	argOutData    返回数据
/// 			ExamDesc 检验所见,strstrRes 诊断意见,strOrderName 检验方法
/// debug:     	d ##Class(EMR.DOC.BL.LisData).GetMultiSubPacsJson()
ClassMethod GetMultiSubLisJson(aItem As EMR.DOC.DTO.LisData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s json = ""
	s count = 0
	s strRes=""
	s jsonRes = {"total":0,"rows":[]}
	if (aItem.OEItemRowID = "")
	{
		 d jsonRes.%ToJSON(argOutData)
		 q "1"
	}
	s idCount=$l(aItem.OEItemRowID, "^")
	f i=1:1:idCount 
	{
		s OeordID = $p(aItem.OEItemRowID, "^", i)
		s EpisodeID =  $p(aItem.EpisodeIDs, "^", i)
		s LabEpisodeNo =  $p(aItem.LabEpisodeNo, "^", i)	
		s key = $i(^CacheTemp)
		k ^TempEMRLisData(key)
		if (aItem.InterFace = "HIS")
		{
			s ds = ##class(EMR.DOC.HISInterface.LisDataSrv).SelectReportByOeordID(OeordID)
		}
		elseif (aItem.InterFace = "数据平台")
		{
			s ds = ##Class(%Library.strResSet).%New("EMR.DOC.HISInterface.PacsDataSrv:GetLisDataDetial")
			d ds.Execute(EpisodeID,"","",OeordID)	
		}
		elseif (aItem.InterFace = "HSBToHis")
		{
			s ds = ##class(EMR.DOC.HISInterface.LisDataSrv).SelectLISReportByOeordID(OeordID)
		}
		//elseif (aItem.InterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		
		While (ds.Next())
		{
			s itemDesc = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(ds.Data("ItemDesc"))
			s ItemResult = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(ds.Data("ItemResult"))
			s abnorFlag=""
			if ((ds.Data("AbnorFlag")="高")||(ds.Data("AbnorFlag")="H"))
			{
				s abnorFlag="↑"
			}
			elseif ((ds.Data("AbnorFlag")="低")||(ds.Data("AbnorFlag")="L"))
			{
				s abnorFlag="↓"
			}
			elseif ((ds.Data("AbnorFlag")="A"))
			{
				s abnorFlag="A"
			}
			s itemUnit = ds.Data("ItemUnit")
			s itemUnitFw = $e(itemUnit,0,1)
			s itemUnit = $case(itemUnitFw,"*":"×","×":"×",:itemUnitFw)_$e(itemUnit,2,*)
			
			s detailData = "[]"
			if (aItem.InterFace = "数据平台")
			{
				s detailData = $g(ds.Data("DetailData"),"[]")
			}
			else
			{
				if (($g(ds.Data("strResDR")) '= ""))
				{
					s detailData = ##Class(EMR.DOC.BL.LisData).GetQryAntstrRes(ds.Data("strResDR"))
				}
			}
			
			s json = json_"{"
			s json = json_"""OeordID"":"""_OeordID_""","
			s json = json_"""LabEpisodeNo"":"""_LabEpisodeNo_""","
			s json = json_"""EpisodeID"":"""_EpisodeID_""","
			s json = json_"""ItemDesc"":"""_itemDesc_""","
			s json = json_"""Synonym"":"""_$case(ds.Data("Synonym"),"":itemDesc,:ds.Data("Synonym"))_""","  
			s json = json_"""ItemResult"":"""_ItemResult_"""," 
			s json = json_"""ItemUnit"":"""_itemUnit_"""," 
			s json = json_"""AbnorFlag"":"""_abnorFlag_"""," 
			s json = json_"""ItemRanges"":"""_ds.Data("ItemRanges")_"""," 
			s json = json_"""ReportDR"":"""_$g(ds.Data("strResDR"))_""","  
			s json = json_"""DetailData"":"_detailData_"" 
			s json = json_"}"
			s Sequence = $g(ds.Data("Sequence"))
			s:(Sequence = "") Sequence = 0
			s ^TempEMRLisData(key,Sequence,count) = json
			s json = ""
			s count = count + 1
		}
		s LisSequence="",j=0
		for
		{
			s LisSequence = $o(^TempEMRLisData(key,LisSequence))
			q:(LisSequence="")
			s order = ""
			for {
				s order = $o(^TempEMRLisData(key,LisSequence,order))
				q:(order = "")
				s:((j'=0)||(i'=1)) strRes = strRes_","
				s strRes = strRes_^TempEMRLisData(key,LisSequence,order)
				s j = j + 1
			}
		}
		k ^TempEMRLisData(key)
	}
	s strRes = "{""total"":"_count_",""rows"":["_strRes_"]}"
	s strRes = $ZSTRIP(strRes,"*C")
	s jsonRes = ##class(%DynamicObject).%FromJSON(strRes)
	d jsonRes.%ToJSON(argOutData)
	q "1"
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

}
