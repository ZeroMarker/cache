Class EMRservice.Ajax.pacsData Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeIds = $Get(%request.Data("EpisodeIDS",1),"")
 	s Id = $Get(%request.Data("ID",1),"")
 	s startDataTime = $Get(%request.Data("StartDateTime",1),"")
 	s endDateTime = $Get(%request.Data("EndDateTime",1),"")
 	///rrtStDateTime、rrtEndDateTime是按回报日期查询的始末条件
 	s rrtStDateTime = $Get(%request.Data("RrtStartDateTime",1),"")
 	s rrtEndDateTime = $Get(%request.Data("RrtEndDateTime",1),"")
	s rrtedFlag = $Get(%request.Data("RrtedFlag",1),"")
 	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	s action = $Get(%request.Data("Action",1),"")
	s interface = $Get(%request.Data("InterFace",1),"")
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	s pacscategoryID = $Get(%request.Data("PacscategoryID",1),"")
	if (action = "GetPacsData")
	{
		s patientID = $Get(%request.Data("PatientID",1),"")
		s dateGap = $Get(%request.Data("DateGap",1),"")
		s searchInput = $Get(%request.Data("SearchInput",1),"")

		d ..GetPacsData(interface,episodeIds,startDataTime,endDateTime,rrtStDateTime,rrtEndDateTime,rrtedFlag,idxStart,idxLast,patientID,dateGap,pacscategoryID,searchInput)
	}
	elseif (action = "GetSubPacs")
	{
		d ..GetSubPacs(interface,episodeIds,Id)
	}
	elseif (action = "GetMultiSubPacs")
	{
		d ..GetMultiSubPacs(interface,episodeIds,Id)
	}	
	Quit $$$OK
}

/// Desc:       取检查项
/// Creator:    Candy
/// Createdate: 2014-4-8
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10 
///             EpisodeIDs:就诊号以","分隔
///             StDate:开始时间
///             EndDate:结束时间
///             RrtStartDate:报告开始时间
///             RrtEndDate:报告结束时间
///             RrtedFlag:报告标识
///             StartPage:返回分页开始页号
///             EndPage:返回分页结束页号
///             PatientID:病人PatientID
///             DateGap:就诊日期间隔,例如90天
/// OutPut:     EpisodeDate:就诊日期,EpisodeSection:就诊科室,EpisodeItemName:医嘱名称,OrdCreateDate:下医嘱日期,OrdCreateTime:下医嘱时间,OEOrdItemDR:医嘱ID,RptRowID:报告ID	
/// OutPut:     检查子项json
/// debug:      w ##Class(EMRservice.Ajax.pacsData).GetPacsData("HIS",34,"2014-02-02","2014-08-15","","","",1,10)
ClassMethod GetPacsData(AInterFace As %String, EpisodeIDs As %String, StDate As %String, EndDate As %String, RrtStartDate As %String = "", RrtEndDate As %String = "", RrtedFlag As %String = "", StartPage As %Integer, EndPage As %Integer, PatientID As %String = "", DateGap As %String = "", PacscategoryID As %String = "", SearchInput As %String = "") As %String
{
	s json = ""
	s result = ""
	s TotalCount = 0
	s count = 0
	s:(RrtedFlag =2) EpisodeIDs = ##Class(EMRservice.Ajax.hisData).GetEpisodeIdsByPatientId(PatientID,RrtedFlag)
	s:(DateGap '= "") EpisodeIDs = ##Class(EMRservice.Ajax.hisData).GetEpisodeIdsByPatientId(PatientID,"",DateGap)
	q:(EpisodeIDs = "") "{""total"":0,""rows"":["_result_"]}"
	s key = $i(^CacheTemp)
	k ^TempEMRPacsData(key)
	///报告时间查询条件的格式转换
	s:(RrtStartDate'="") RrtStartDate = $zdh(RrtStartDate,3)
	s:(RrtEndDate'="") RrtEndDate= $zdh(RrtEndDate,3)
	s length = $l(EpisodeIDs,",")
	for I=1:1:length
	{
		s episodeId = $p(EpisodeIDs,",",I)
		s IsPreInPatient = $p($g(^PAADM(episodeId,"DHC")),"^",56)
		if (IsPreInPatient = "Y")
		{
			s tmpStDate = $Case(StDate,"":$p($g(^PAADM(episodeId)),"^",34),:$zdh(StDate,3))
			s tmpEndDate = $p($h,",",1)
		}
		else
		{
			s tmpStDate = $Case(StDate,"":$p($g(^PAADM(episodeId)),"^",6),:$zdh(StDate,3))
			s episodeType= $p(^PAADM(episodeId),"^",2)
			//检查的开始时间取建住院证的时间，南大二附院个性化修改
			s stDateType = ##Class(EMRservice.SystemParameter).GetResourceStartDate()
			if ((stDateType = "Y")&&(episodeType = "I"))
			{
				s patientId = $p($g(^PAADM(episodeId)),"^",1)
				s bookId = $o(^DHCDocIPBK(0,"PatientID",patientId,""))
				s bookStDate = $p($g(^DHCDocIPBK(bookId)),"^",10)
				s tmpStDate = bookStDate
			}
			s tmpEndDate = $Case(EndDate,"":$P($G(^PAADM(episodeId)),"^",17),:$zdh(EndDate,3))
		}
		s:(tmpEndDate = "") tmpEndDate = $p($h,",",1)
		s episodeDate = $ZD($p($g(^PAADM(episodeId)),"^",6),3)	 	
		s deptId = $p(^PAADM(episodeId),"^",4)
		s deptDesc = $Case(deptId,"":"",:$p(^CTLOC(deptId),"^",2))
		s:($f(deptDesc,"-") '= 0) deptDesc = $p(deptDesc,"-",2)
		
		if (AInterFace = "HIS")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectPACSItemListByDate")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		elseif (AInterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLPacsData:GetPacsDataList")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		elseif (AInterFace = "HSBToHis")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectPACSItemListByDate")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		
		///若报告时间查询条件为当天
		if (RrtStartDate'="")&&(RrtStartDate=RrtEndDate)
		{
			While (ds.Next())
			{
				continue:($zdh(ds.Data("RrtDate"),3)'=RrtStartDate)
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		///若报告时间查询条件为三天或一周
		elseif(RrtStartDate'="")&&(RrtStartDate'=RrtEndDate)
		{
			While (ds.Next())
			{
				continue:ds.Data("RrtDate")=""
				continue:'(($zdh(ds.Data("RrtDate"),3)>=RrtStartDate)&&($zdh(ds.Data("RrtDate"),3)<=RrtEndDate))
				s TotalCount = TotalCount + 1 
				d setJson
			 }
		}
		///若报告时间查询条件为本次就诊
		elseif(RrtedFlag =1)
		{
			While (ds.Next())
			{
				continue:'(ds.Data("RrtDate")'="")
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		elseif(RrtedFlag =0)
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
				if ((StartPage <= i)&(i <= EndPage))
				{
					s:(j'=0) result = result_","
					s result = result_^TempEMRPacsData(key,PacsRrtDate,PacsRrtTime,order)
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
	k ^TempEMRPacsData(key)
	s result = "{""total"":"_TotalCount_",""rows"":["_result_"]}"
	s result = $ZSTRIP(result,"*C")
	w result
	q
setJson
	if (PacscategoryID '="")
	{
		s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(ds.Data("OEOrdItemDR"))
		q:(ARCICatInfo = "")
		s ARCICatDr = $p(ARCICatInfo,"^",1)
		s ARCICatID = $o(^DHCAPARCCA(0,"O",ARCICatDr,""))
		q:(ARCICatID = "")
		q:(PacscategoryID '= ARCICatID)		
	}
	if (SearchInput'="")
	{
		q:(ds.Data("ItemName")'[SearchInput)
	}
	s isReferenceOEord = ##Class(EMRservice.BL.BLPacsDataReference).GetIsReferenceOEord(episodeId,ds.Data("OEOrdItemDR"))
	s json = json_"{"
	s json = json_"""EpisodeDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",episodeDate)_""","
	s json = json_"""EpisodeID"":"""_episodeId_""","
	s json = json_"""DeptDesc"":"""_deptDesc_""","
	s json = json_"""ItemName"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ItemName"))_"""," 
	s json = json_"""OrdCreateDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("OrdCreateDate"))_"""," 
	s json = json_"""OrdCreateTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("OrdCreateTime"))_""","
	s json = json_"""OEOrdItemDR"":"""_ds.Data("OEOrdItemDR")_""","
	s json = json_"""RptRowID"":"""_ds.Data("RptRowID")_""","
	s json = json_"""ReportNo"":"""_$g(ds.Data("ReportNo"))_""","
	s json = json_"""IsReferenceOEord"":"""_isReferenceOEord_""","
	s json = json_"""RrtDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("RrtDate"))_""","

    if ($g(ds.Data("RptURL")) '= "")
    {
		s ReportURL = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("RptURL"))
		s json = json_"""ReportURL"":""<a onclick=reportOrImageLink('"_ReportURL_"')>报告</a>"","
    }
    else
	{
		s json = json_"""ReportURL"":"""_""_""","
	}
    if ($g(ds.Data("ImgURL")) '= "")
    {
        s ImgURL = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ImgURL"))
		s json = json_"""ImageURL"":""<a onclick=reportOrImageLink('"_ImgURL_"')>图像</a>"","
    }
    else
	{
		s json = json_"""ImageURL"":"""_""_""","
	}	

	s json = json_"""RISRSysCode"":"""_$g(ds.Data("RISRSysCode"))_""","
	s json = json_"""RrtTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("RrtTime"))_""""
	
	s json = json_"}"
	if (##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("RrtDate")) '= "")
	{
		s RrtDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("RrtDate"))
	}
	else
	{
		s RrtDate = "00000"
	}
	if (##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("RrtTime")) '= "")
	{
		s RrtTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("RrtTime"))
	}
	else
	{
		s RrtTime = "00000"
	}
	s ^TempEMRPacsData(key,RrtDate,RrtTime,count) = json
	s json = ""
	s count = count + 1
	q
}

/// Desc:       取检查子项
/// Creator:    Candy
/// Createdate: 2014-4-8
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10
///             OEItemRowID 检查医嘱ID
/// OutPut:     ExamDesc 检查所见,strResult 诊断意见,strOrderName 检查方法
/// debug:      d ##Class(EMRservice.Ajax.pacsData).GetSubPacs("HIS",174,"41||73")
ClassMethod GetSubPacs(AInterFace As %String, EPisodeID As %String, OEItemRowID As %String) As %String
{
	s json = ""
	s count = 0
	q:(OEItemRowID = "") "{""total"":0,""rows"":["_json_"]}"
	
	if (AInterFace = "HIS")
	{
		s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectReportByOeordID")
		d ds.Execute(OEItemRowID)
	}
	elseif (AInterFace = "数据平台")
	{
		s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLPacsData:GetPacsDataList")
		d ds.Execute(EPisodeID,"","",OEItemRowID)
	}
	elseif (AInterFace = "HSBToHis")
	{
		s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectReportByOeordID")
		d ds.Execute(OEItemRowID)
	}
	//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口

	While (ds.Next())
	{
		s ExamDesc = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ExamDesc"))
		s strResult = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("strResult"))
		s strOrderName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("strOrderName"))
		s ExamDesc = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(ExamDesc)
		s strResult = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(strResult)
		s strOrderName = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(strOrderName)
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""OEItemRowID"":"""_OEItemRowID_""","
		s json = json_"""ExamDesc"":"""_ExamDesc_""","
		s json = json_"""strResult"":"""_strResult_"""," 
		s json = json_"""strOrderName"":"""_strOrderName_"""" 
		s json = json_"}"
		s count = count + 1
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	w json
}

/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10
ClassMethod GetMultiSubPacs(AInterFace As %String, EPisodeID As %String, OEItemRowID As %String) As %String
{
	s json = ""
	s count = 0
	q:(OEItemRowID = "") "{""total"":0,""rows"":["_json_"]}"
	
	s idCount=$l(OEItemRowID, "^")
	f i=1:1:idCount 
	{
		s OeordID = $p(OEItemRowID, "^", i)	
		
		if (AInterFace = "HIS")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectReportByOeordID")
			d ds.Execute(OEItemRowID)
		}
		elseif (AInterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLPacsData:GetPacsDataList")
			d ds.Execute(EPisodeID,"","",OeordID)
		}
		elseif (AInterFace = "HSBToHis")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectReportByOeordID")
			d ds.Execute(OEItemRowID)
		}
		//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
			
		While (ds.Next())
		{
			s ExamDesc = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ExamDesc"))
			s strResult = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("strResult"))
			s strOrderName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("strOrderName"))
			s ExamDesc = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(ds.Data("ExamDesc"))
			s strResult = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(ds.Data("strResult"))
			s strOrderName = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(ds.Data("strOrderName"))
			s:(count '=0) json =json_","
			s json = json_"{"
			s json = json_"""OEItemRowID"":"""_OEItemRowID_""","
			s json = json_"""ExamDesc"":"""_ExamDesc_""","
			s json = json_"""strResult"":"""_strResult_"""," 
			s json = json_"""strOrderName"":"""_strOrderName_"""" 
			s json = json_"}"
			s count = count + 1
		}
	}
	
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	w json
}

}
