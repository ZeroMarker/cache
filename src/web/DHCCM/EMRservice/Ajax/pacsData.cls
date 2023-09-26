Class web.DHCCM.EMRservice.Ajax.pacsData Extends %CSP.Page
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
	if (action = "GetPacsData")
	{
 		d ..GetPacsData(interface,episodeIds,startDataTime,endDateTime,rrtStDateTime,rrtEndDateTime,rrtedFlag,idxStart,idxLast)
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
/// Input:      EpisodeIDs:就诊号以","分隔
///             StDate:开始时间
///             EndDate:结束时间
///             RrtStartDate:报告开始时间
///             RrtEndDate:报告结束时间
///             RrtedFlag:报告标识
///             StartPage:返回分页开始页号
///             EndPage:返回分页结束页号
/// OutPut:     EpisodeDate:就诊日期,EpisodeSection:就诊科室,EpisodeItemName:医嘱名称,OrdCreateDate:下医嘱日期,OrdCreateTime:下医嘱时间,OEOrdItemDR:医嘱ID,RptRowID:报告ID	
/// OutPut:     检查子项json
/// debug:      w ##Class(web.DHCCM.EMRservice.Ajax.pacsData).GetPacsData(34,"2014-02-02","2014-08-15","","","",1,10)
ClassMethod GetPacsData(InterFace As %String, EpisodeIDs As %String, StDate As %String, EndDate As %String, RrtStartDate As %String = "", RrtEndDate As %String = "", RrtedFlag As %String = "", StartPage As %Integer, EndPage As %Integer) As %String
{
	s json = ""
	s TotalCount = 0
	q:(EpisodeIDs = "") "{""total"":0,""rows"":["_json_"]}"
	s length = $l(EpisodeIDs,",")
	for I=1:1:length
	{
		s episodeId = $p(EpisodeIDs,",",I)
		s tmpStDate = $Case(StDate,"":$p($g(^PAADM(episodeId)),"^",6),:$zdh(StDate,3))
		s tmpEndDate = $Case(EndDate,"":$P($G(^PAADM(episodeId)),"^",17),:$zdh(EndDate,3))
		s:(tmpEndDate = "") tmpEndDate = $p($h,",",1)
		///报告时间查询条件的格式转换
		s:(RrtStartDate'="") RrtStartDate = $zdh(RrtStartDate,3)
		s:(RrtEndDate'="") RrtEndDate= $zdh(RrtEndDate,3)
		s episodeDate = $ZD($p($g(^PAADM(episodeId)),"^",6),3)	 	
		s deptId = $p(^PAADM(episodeId),"^",4)
		s deptDesc = $Case(deptId,"":"",:$p(^CTLOC(deptId),"^",2))
		s:($f(deptDesc,"-") '= 0) deptDesc = $p(deptDesc,"-",2)

		if (InterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCCM.EMRservice.BL.BLPacsData:GetPacsDataList")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		else
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectPACSItemListByDate")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)	
		}
		
		///若报告时间查询条件为当天
		if (RrtStartDate'="")&&(RrtStartDate=RrtEndDate)
		{
			While (ds.Next())
			{
				continue:($zdh(ds.Data("RrtDate"),3)'=RrtStartDate)
				s TotalCount = TotalCount + 1 
				d:((StartPage-1) <= (TotalCount-1) )&&(EndPage > TotalCount) setJson
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
				d:((StartPage-1) <= (TotalCount-1) )&&(EndPage > TotalCount) setJson
			 }
		}
		///若报告时间查询条件为本次就诊
		elseif(RrtedFlag =1)
		{
			While (ds.Next())
			{
				continue:'(ds.Data("RrtDate")'="")
				s TotalCount = TotalCount + 1 
				d:((StartPage-1) <= (TotalCount-1) )&&(EndPage > TotalCount) setJson
			}
		}
		elseif(RrtedFlag =0)
		{
			///未报告
			While (ds.Next())
			{
				continue:'(ds.Data("RrtDate")="")
				s TotalCount = TotalCount + 1 
				d:((StartPage-1) <= (TotalCount-1) )&&(EndPage > TotalCount) setJson
			}
		}else
		{
			///所有医嘱
			while (ds.Next())
			{
				 s TotalCount = TotalCount + 1 
				 d:((StartPage-1) <= (TotalCount-1) )&&(EndPage > TotalCount) setJson
			}
		}
	}
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_TotalCount_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
 	w json
setJson
	s json = json_"{"
	s json = json_"""EpisodeDate"":"""_episodeDate_""","
	s json = json_"""EpisodeID"":"""_episodeId_""","
	s json = json_"""DeptDesc"":"""_deptDesc_""","
	s json = json_"""ItemName"":"""_ds.Data("ItemName")_"""," 
	s json = json_"""OrdCreateDate"":"""_ds.Data("OrdCreateDate")_"""," 
	s json = json_"""OrdCreateTime"":"""_ds.Data("OrdCreateTime")_""","
	s json = json_"""OEOrdItemDR"":"""_ds.Data("OEOrdItemDR")_""","
	s json = json_"""RptRowID"":"""_ds.Data("RptRowID")_""","
	s json = json_"""RrtDate"":"""_ds.Data("RrtDate")_""","
	s json = json_"""RrtTime"":"""_ds.Data("RrtTime")_""""
	s json = json_"}"
	s json =json_","
	q
}

/// Desc:       取检查子项
/// Creator:    Candy
/// Createdate: 2014-4-8
/// Input:      OEItemRowID 检查医嘱ID
/// OutPut:     ExamDesc 检查所见,strResult 诊断意见,strOrderName 检查方法
/// debug:      d ##Class(web.DHCCM.EMRservice.Ajax.pacsData).GetSubPacs("41||73")
ClassMethod GetSubPacs(InterFace As %String, EPisodeID As %String, OEItemRowID As %String) As %String
{
	s json = ""
	s count = 0
	q:(OEItemRowID = "") "{""total"":0,""rows"":["_json_"]}"
	if (InterFace = "数据平台")
	{
		s ds = ##Class(%Library.ResultSet).%New("web.DHCCM.EMRservice.BL.BLPacsData:GetPacsDataList")
		d ds.Execute(EPisodeID,"","",OEItemRowID)
	}
	else
	{
		s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectReportByOeordID")
		d ds.Execute(OEItemRowID)	
	}

	While (ds.Next())
	{
		s ExamDesc = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ExamDesc"))
		s strResult = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("strResult"))
		s strOrderName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("strOrderName"))
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

ClassMethod GetMultiSubPacs(EPisodeID As %String, OEItemRowID As %String) As %String
{
	s json = ""
	s count = 0
	q:(OEItemRowID = "") "{""total"":0,""rows"":["_json_"]}"
	
	s idCount=$l(OEItemRowID, "^")
	f i=1:1:idCount 
	{
		s OeordID = $p(OEItemRowID, "^", i)	
		if (InterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCCM.EMRservice.BL.BLPacsData:GetPacsDataList")
			d ds.Execute(EPisodeID,"","",OeordID)
		}
		else
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectReportByOeordID")
			d ds.Execute(OEItemRowID) 
		}	
		While (ds.Next())
		{
			s ExamDesc = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ExamDesc"))
			s strResult = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("strResult"))
			s strOrderName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("strOrderName"))
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
