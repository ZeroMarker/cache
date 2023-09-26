/// 名称:	EMR.OP.BL.PacsData
/// 描述:	门急诊检查结果功能相关业务
/// 编写者:	yejian
/// 编写日期:2022-10-12
/// 产品组:	电子病历产品组
Class EMR.DOC.BL.PacsData Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取检查主数据
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_PACSDATA","params":{"interface":"HIS","aItem.EpisodeIDs":"4","startDateTime":"","endDateTime":"","rrtStartDateTime":"","rrtEndDateTime":"","rrtedFlag":"","patientID":"","dateGap":"","page":1,"rows":20},"product":"OP"}
/// 			interface: 调用接口标识(默认HIS) ,episodeIDs:就诊号以","分隔,startDateTime:开始时间,endDateTime:结束时间,rrtStartDateTime:报告开始时间,	
///             rrtEndDateTime:报告结束时间,rrtedFlag:报告标识,patientID:病人PatientID,dateGap:就诊日期间隔,例如90天,page:当前页
///             rows:每页行数		
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPacsData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	;s argInJson= {"action":"GET_PACSDATA","params":{"page":"1","rows":"20","interface":"HSBToHis","episodeIDs":"285","startDateTime":"","endDateTime":"","rrtStartDateTime":"","rrtEndDateTime":"","patientID":"","rrtedFlag":"1","dateGap":"","pacscategoryID":""},"product":"OP"}
    
	s dtoItem = ##class(EMR.DOC.DTO.PacsData).%New()
	s dtoItem.Product=argInJson.product
	s interface=argInJson.params.interface
    s dtoItem.InterFace = $CASE(interface,"":"HIS",:interface)
    s dtoItem.EpisodeIDs=argInJson.params.episodeIDs
    s dtoItem.PatientID=argInJson.params.patientID
    s dtoItem.StDate=argInJson.params.startDateTime
    s dtoItem.EndDate=argInJson.params.endDateTime
    s dtoItem.RrtStartDate=argInJson.params.rrtStartDateTime
    s dtoItem.RrtEndDate=argInJson.params.rrtEndDateTime
    s dtoItem.RrtedFlag=argInJson.params.rrtedFlag
    s dtoItem.PacscategoryID = argInJson.params.pacscategoryID
    s page = argInJson.params.page  
    s rows=argInJson.params.rows
    ;s:(page="") page=1,rows=20
    s:(page'="") dtoItem.StartPage = rows * (page -1) + 1
	s:(page'="") dtoItem.EndPage = dtoItem.StartPage + rows -1	
	s dtoItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.PacsData).GetPacsDataJson(dtoItem,.argOutData)
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

/// Desc:       获取检查主数据
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aItem 检查对象
/// OutPut:    	argOutData    返回数据
/// 		    EpisodeDate:就诊日期,EpisodeSection:就诊科室,EpisodeItemName:医嘱名称,OrdCreateDate:下医嘱日期,OrdCreateTime:下医嘱时间,OEOrdItemDR:医嘱ID,RptRowID:报告ID	
/// OutPut:     检查子项json
/// debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			w ##Class(EMR.DOC.BL.PacsData).GetPacsDataJson("HIS",4,"2014-02-02","2014-08-15","","","",1,10,.argOutData)
ClassMethod GetPacsDataJson(aItem As EMR.DOC.DTO.PacsData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = ""
	q:(aItem.StartPage="") "-1^分页page、rows未获取到值"
	s json = ""
	s jsonRes ={"total":0,"rows":[]}
	s TotalCount = 0
	s count = 0
	s:(aItem.RrtedFlag =2) aItem.EpisodeIDs = ##Class(EMR.DOC.HISInterface.EpisodeInfo).GetEpisodeIdsByPatientId(aItem.PatientID,aItem.RrtedFlag,"",aItem.Product,aItem.LangID)
	s:(aItem.DateGap '= "") aItem.EpisodeIDs = ##Class(EMR.DOC.HISInterface.EpisodeInfo).GetEpisodeIdsByPatientId(aItem.PatientID,"",aItem.DateGap,aItem.Product,aItem.LangID)
	if (aItem.EpisodeIDs = "")
	{
		d jsonRes.%ToJSON(argOutData)
		q "1"
	}
	s key = $i(^CacheTemp)
	k ^TempEMRPacsData(key)
	///报告时间查询条件的格式转换
	s:(aItem.RrtStartDate'="") aItem.RrtStartDate = $zdh(aItem.RrtStartDate,3)
	s:(aItem.RrtEndDate'="") aItem.RrtEndDate= $zdh(aItem.RrtEndDate,3)
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
			s ds = ##class(EMR.DOC.HISInterface.PacsDataSrv).SelectPACSItemListByDate(episodeId,tmpStDate,tmpEndDate)
		}
		elseif (aItem.InterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("EMR.DOC.HISInterface.PacsDataSrv:GetPacsDataList")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		elseif (aItem.InterFace = "HSBToHis")
		{
			s ds = ##class(EMR.DOC.HISInterface.PacsDataSrv).SelectPACSItemListData(episodeId,tmpStDate,tmpEndDate)
		}
		//elseif (aItem.InterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		
		///若报告时间查询条件为当天
		if (aItem.RrtStartDate'="")&&(aItem.RrtStartDate=aItem.RrtEndDate)
		{
			While (ds.Next())
			{
				continue:($zdh(ds.Data("RrtDate"),3)'=aItem.RrtStartDate)
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		///若报告时间查询条件为三天或一周
		elseif(aItem.RrtStartDate'="")&&(aItem.RrtStartDate'=aItem.RrtEndDate)
		{
			While (ds.Next())
			{
				continue:ds.Data("RrtDate")=""
				continue:'(($zdh(ds.Data("RrtDate"),3)>=aItem.RrtStartDate)&&($zdh(ds.Data("RrtDate"),3)<=aItem.RrtEndDate))
				s TotalCount = TotalCount + 1 
				d setJson
			 }
		}
		///若报告时间查询条件为本次就诊
		elseif(aItem.RrtedFlag =1)
		{
			While (ds.Next())
			{
				continue:'(ds.Data("RrtDate")'="")
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		elseif(aItem.RrtedFlag =0)
		{
			///未报告
			While (ds.Next())
			{
				continue:'(ds.Data("RrtDate")="")
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
	s PacsRrtDate="",j=0,i=1
	for
	{
		s PacsRrtDate = $o(^TempEMRPacsData(key,PacsRrtDate),-1)
		q:(PacsRrtDate="")
		s PacsRrtTime=""
		for
		{
			s PacsRrtTime = $o(^TempEMRPacsData(key,PacsRrtDate,PacsRrtTime),-1)
			q:(PacsRrtTime = "")
			s order = ""
			for {
				s order = $o(^TempEMRPacsData(key,PacsRrtDate,PacsRrtTime,order))
				q:(order = "")
				if ((aItem.StartPage <= i)&(i <= aItem.EndPage))
				{
					s:(j'=0) strRes = strRes_","
					s strRes = strRes_^TempEMRPacsData(key,PacsRrtDate,PacsRrtTime,order)
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
	k ^TempEMRPacsData(key)
	s strRes = "{""total"":"_TotalCount_",""rows"":["_strRes_"]}"
	s strRes = $ZSTRIP(strRes,"*C")
	s jsonRes = ##class(%DynamicObject).%FromJSON(strRes)
	d jsonRes.%ToJSON(argOutData)
	q "1"
setJson
	if (aItem.PacscategoryID '="")
	{
		s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(ds.Data("OEOrdItemDR"))
		q:(ARCICatInfo = "")
		s ARCICatDr = $p(ARCICatInfo,"^",1)
		s ARCICatID = $o(^DHCAPARCCA(0,"O",ARCICatDr,""))
		q:(ARCICatID = "")
		q:(aItem.PacscategoryID '= ARCICatID)		
	}
	s json = json_"{"
	s json = json_"""EpisodeDate"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",episodeDate)_""","
	s json = json_"""EpisodeID"":"""_episodeId_""","
	s json = json_"""DeptDesc"":"""_deptDesc_""","
	s json = json_"""ItemName"":"""_##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(ds.Data("ItemName"))_"""," 
	s json = json_"""OrdCreateDate"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("OrdCreateDate"))_"""," 
	s json = json_"""OrdCreateTime"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("OrdCreateTime"))_""","
	s json = json_"""OEOrdItemDR"":"""_ds.Data("OEOrdItemDR")_""","
	s json = json_"""RptRowID"":"""_ds.Data("RptRowID")_""","
	s json = json_"""ReportNo"":"""_$g(ds.Data("ReportNo"))_""","
	s json = json_"""RrtDate"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("RrtDate"))_""","

    if ($g(ds.Data("RptURL")) '= "")
    {
		s ReportURL = ds.Data("RptURL")
		s json = json_"""ReportURL"":""<a onclick=reportOrImageLink('"_ReportURL_"')>报告</a>"","
    }
    else
	{
		s json = json_"""ReportURL"":"""_""_""","
	}
    if ($g(ds.Data("ImgURL")) '= "")
    {
		s json = json_"""ImageURL"":""<a onclick=reportOrImageLink('"_ds.Data("ImgURL")_"')>图像</a>"","
    }
    else
	{
		s json = json_"""ImageURL"":"""_""_""","
	}	

	s json = json_"""RISRSysCode"":"""_$g(ds.Data("RISRSysCode"))_""","
	s json = json_"""RrtTime"":"""_##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("RrtTime"))_""""
	
	s json = json_"}"
	if (##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("RrtDate")) '= "")
	{
		s RrtDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("RrtDate"))
	}
	else
	{
		s RrtDate = "00000"
	}
	if (##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("RrtTime")) '= "")
	{
		s RrtTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("RrtTime"))
	}
	else
	{
		s RrtTime = "00000"
	}
	s ^TempEMRPacsData(key,RrtDate,RrtTime,count) = json
	s json = ""
	s count = count + 1
	q
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

/// Desc:       获取检查子数据
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_SUBPACSDATA","params":{"interface":"HIS","episodeIDs":"4","oeitemRowID":1},"product":"OP"}
/// 			interface: 调用接口标识(默认HIS) ,episodeIDs:就诊号以","分隔,oeitemRowID:医嘱ID
///             rows:每页行数		
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSubPacs(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.PacsData).%New()
	s dtoItem.Product=argInJson.product
	s interface=argInJson.params.interface
    s dtoItem.InterFace = $CASE(interface,"":"HIS",:interface)
    s dtoItem.EpisodeIDs=argInJson.params.episodeIDs
    s dtoItem.OEItemRowID = argInJson.params.oeitemRowID
	
    s strRes = ##Class(EMR.DOC.BL.PacsData).GetSubPacsJson(dtoItem,.argOutData)
	//1 获取成功
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

/// Desc:       取检查子项
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aItem 检查对象
///             OEItemRowID 检查医嘱ID
/// OutPut:    	argOutData    返回数据
/// 			ExamDesc 检查所见,strResult 诊断意见,strOrderName 检查方法
/// debug:     	d ##Class(EMR.DOC.BL.PacsData).GetSubPacsJson()
ClassMethod GetSubPacsJson(aItem As EMR.DOC.DTO.PacsData, ByRef argOutData As %GlobalBinaryStream) As %String
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
	
	if (aItem.InterFace = "HIS")
	{
		s ds = ##Class(EMR.DOC.HISInterface.PacsDataSrv).SelectReportByOeordID(aItem.OEItemRowID)
	}
	elseif (aItem.InterFace = "数据平台")
	{
		s ds = ##Class(%Library.ResultSet).%New("EMR.DOC.HISInterface.PacsDataSrv:GetPacsDataList")
		d ds.Execute(aItem.EpisodeID,"","",aItem.OEItemRowID)
	}
	elseif (aItem.InterFace = "HSBToHis")
	{
		s ds = ##Class(EMR.DOC.HISInterface.PacsDataSrv).SelectReportData(aItem.OEItemRowID)
	}
	//elseif (aItem.InterFace = ...){....}   add by Lina 2016-11-10 调用其它接口

	While (ds.Next())
	{
		s ExamDesc = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(ds.Data("ExamDesc"))
		s strResult = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(ds.Data("strResult"))
		s strOrderName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(ds.Data("strOrderName"))
		s ExamDesc = ##Class(EMR.DOC.COM.EscapeSpecialWord).HtmlEscape(ExamDesc)
		s strResult = ##Class(EMR.DOC.COM.EscapeSpecialWord).HtmlEscape(strResult)
		s strOrderName = ##Class(EMR.DOC.COM.EscapeSpecialWord).HtmlEscape(strOrderName)
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""OEItemRowID"":"""_aItem.OEItemRowID_""","
		s json = json_"""ExamDesc"":"""_ExamDesc_""","
		s json = json_"""strResult"":"""_strResult_"""," 
		s json = json_"""strOrderName"":"""_strOrderName_"""" 
		s json = json_"}"
		s count = count + 1
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	s jsonRes = ##class(%DynamicObject).%FromJSON(json)
	d jsonRes.%ToJSON(argOutData)
	q "1"
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

/// Desc:       获取多个检查子数据
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_MULSUBPACSDATA","params":{"interface":"HIS","episodeIDs":"4","oeitemRowID":"3||71"},"product":"OP"}
/// 			interface: 调用接口标识(默认HIS) ,episodeIDs:就诊号以","分隔,oeitemRowID:医嘱ID以"^"分隔
///             rows:每页行数		
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetMultiSubPacs(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.PacsData).%New()
	s dtoItem.Product=argInJson.product
	s interface=argInJson.params.interface
    s dtoItem.InterFace = $CASE(interface,"":"HIS",:interface)
    s dtoItem.EpisodeIDs=argInJson.params.episodeIDs
    s dtoItem.OEItemRowID = argInJson.params.oeitemRowID
	
    s strRes = ##Class(EMR.DOC.BL.PacsData).GetMultiSubPacsJson(dtoItem,.argOutData)
	//1 获取成功
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

/// Desc:       取多个检查子项
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aItem 检查对象
///             OEItemRowID 检查医嘱ID
/// OutPut:    	argOutData    返回数据
/// 			ExamDesc 检查所见,strResult 诊断意见,strOrderName 检查方法
/// debug:     	d ##Class(EMR.DOC.BL.PacsData).GetMultiSubPacsJson()
ClassMethod GetMultiSubPacsJson(aItem As EMR.DOC.DTO.PacsData, ByRef argOutData As %GlobalBinaryStream) As %String
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
	
	s idCount=$l(aItem.OEItemRowID, "^")
	f i=1:1:idCount 
	{
		s OeordID = $p(aItem.OEItemRowID, "^", i)	
		
		if (aItem.InterFace = "HIS")
		{
			s ds = ##Class(EMR.DOC.HISInterface.PacsDataSrv).SelectReportByOeordID(OeordID)
		}
		elseif (aItem.InterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("EMR.DOC.HISInterface.PacsDataSrv:GetPacsDataList")
			d ds.Execute(aItem.EpisodeID,"","",OeordID)
		}
		elseif (aItem.InterFace = "HSBToHis")
		{
			s ds = ##Class(EMR.DOC.HISInterface.PacsDataSrv).SelectReportData(OeordID)
		}
		//elseif (aItem.InterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
			
		While (ds.Next())
		{
			s ExamDesc = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(ds.Data("ExamDesc"))
			s strResult = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(ds.Data("strResult"))
			s strOrderName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(ds.Data("strOrderName"))
			s ExamDesc = ##Class(EMR.DOC.COM.EscapeSpecialWord).HtmlEscape(ds.Data("ExamDesc"))
			s strResult = ##Class(EMR.DOC.COM.EscapeSpecialWord).HtmlEscape(ds.Data("strResult"))
			s strOrderName = ##Class(EMR.DOC.COM.EscapeSpecialWord).HtmlEscape(ds.Data("strOrderName"))
			s:(count '=0) json =json_","
			s json = json_"{"
			s json = json_"""OEItemRowID"":"""_OeordID_""","
			s json = json_"""ExamDesc"":"""_ExamDesc_""","
			s json = json_"""strResult"":"""_strResult_"""," 
			s json = json_"""strOrderName"":"""_strOrderName_"""" 
			s json = json_"}"
			s count = count + 1
		}
	}
	
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	s jsonRes = ##class(%DynamicObject).%FromJSON(json)
	d jsonRes.%ToJSON(argOutData)
	q "1"
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

}
