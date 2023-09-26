Class web.DHCCM.EMRservice.Ajax.lisData Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
 	s Id = $Get(%request.Data("ID",1),"")
 	s startDateTime = $Get(%request.Data("StartDateTime",1),"")
 	s endDateTime = $Get(%request.Data("EndDateTime",1),"")
 	///authStDateTime、authEndDateTime是按审核日期查询的始末条件
 	s authStDateTime = $Get(%request.Data("AuthStartDateTime",1),"")
 	s authEndDateTime = $Get(%request.Data("AuthEndDateTime",1),"")
 	///审核标识authorizedFlag
 	s authorizedFlag = $Get(%request.Data("AuthorizedFlag",1),"")
 	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	s action = $Get(%request.Data("Action",1),"")
	s interface = $Get(%request.Data("InterFace",1),"")
	s labEpisodeNo = $Get(%request.Data("LabEpisodeNo",1),"")
	if (action = "GetLisData")
	{
 		w ..GetLisData(interface,episodeId,startDateTime,endDateTime,authStDateTime,authEndDateTime,authorizedFlag,idxStart,idxLast)
	}
	elseif (action = "GetSubLis")
	{
		w ..GetSubLis(interface,episodeId,Id,labEpisodeNo)
	}
	elseif (action = "GetMultiSubLis")
	{
		w ..GetMultiSubLis(interface,episodeId,Id,labEpisodeNo)
	}	
	Quit $$$OK
}

/// Desc:       取检验项
/// Creator:    Candy
/// Createdate: 2014-4-8
/// Input:      EpisodeID:就诊号
///             StDate:开始时间
///             EndDate:结束时间
///             AuthStDate:审核查询开始时间
///             AuthEndDate:审核查询结束时间
///             AuthorizedFlag:审核标识
///             StartPage:返回分页开始页号
///             EndPage:返回分页结束页号
/// Output:     EpisodeDate:就诊日期,DeptDesc:就诊科室,OEordItemRowID:医嘱ID,OEordItemDesc:医嘱名称,LabEpisodeNo:标本号,
///             SpecimenDesc:标本类型,CollectionDate:标本采集日期,CollectionTime:标本采集时间,ReceiveDate:标本接收日期,
///             ReceiveTime:标本接收时间,AuthorisationDate:标本审核日期,AuthorisationTime:标本审核时间,
///             ExistReport:是否有报告(Y:存在，N:不存在)
///             w ##Class(web.DHCCM.EMRservice.Ajax.lisData).GetLisData("34","","","","","",1,10)
ClassMethod GetLisData(InterFace As %String, EpisodeIDs As %String, StDate As %String, EndDate As %String, AuthStDate As %String = "", AuthEndDate As %String = "", AuthorizedFlag As %String = "", StartPage As %Integer, EndPage As %Integer) As %String
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
		///审核时间查询条件的格式转换
		s:(AuthStDate'="") AuthStDate = $zdh(AuthStDate,3)
		s:(AuthEndDate'="") AuthEndDate= $zdh(AuthEndDate,3)
		s episodeDate = $ZD($p($g(^PAADM(episodeId)),"^",6),3)	 	
		s deptId = $p(^PAADM(episodeId),"^",4)
		s deptDesc = $Case(deptId,"":"",:$p(^CTLOC(deptId),"^",2))
		s:($f(deptDesc,"-") '= 0) deptDesc = $p(deptDesc,"-",2)
		
		if (InterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCCM.EMRservice.BL.BLLisData:GetLisDataList")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)		
		}
		else
		{
			s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectLISItemListByDate")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		
		///若审核时间查询条件为当天
		if (AuthStDate'="")&&(AuthStDate=AuthEndDate)
		{
		While (ds.Next())
			{
				continue:ds.Data("AuthorisationDate")=""
				continue:($zdh(ds.Data("AuthorisationDate"),3)'=AuthStDate)
				s TotalCount = TotalCount + 1 
				d:((StartPage-1) <= (TotalCount-1) )&&(EndPage >= TotalCount) setJson
			}
		}
		///若审核时间查询条件为三天或一周
		elseif(AuthStDate'="")&&(AuthStDate'=AuthEndDate)
		{
			While (ds.Next())
			{
				continue:ds.Data("AuthorisationDate")=""
				continue:'(($zdh(ds.Data("AuthorisationDate"),3)>=AuthStDate)&&($zdh(ds.Data("AuthorisationDate"),3)<=AuthEndDate))
				s TotalCount = TotalCount + 1 
				d:((StartPage-1) <= (TotalCount-1) )&&(EndPage >= TotalCount) setJson
			 }
		}
		///若审核时间查询条件为本次就诊
		elseif(AuthorizedFlag = 1)
		{
			While (ds.Next())
			{
				continue:'(ds.Data("AuthorisationDate")'="")
				s TotalCount = TotalCount + 1 
				d:((StartPage-1) <= (TotalCount-1) )&&(EndPage >= TotalCount) setJson
			}
		}
		///未审核
		elseif(AuthorizedFlag = 0)
		{
			While (ds.Next())
			{
				continue:'(ds.Data("AuthorisationDate")="")
				s TotalCount = TotalCount + 1 
				d:((StartPage-1) <= (TotalCount-1) )&&(EndPage >= TotalCount) setJson
			}
		}else
		{
			while (ds.Next())
			{
				s TotalCount = TotalCount + 1 
				d:((StartPage-1) <= (TotalCount-1) )&&(EndPage >= TotalCount) setJson
			}
		}
	}
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_TotalCount_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
 	q json
 	q
setJson
	s json = json_"{"
	s json = json_"""EpisodeDate"":"""_episodeDate_""","
	s json = json_"""EpisodeID"":"""_episodeId_""","
	s json = json_"""DeptDesc"":"""_deptDesc_""","
	s json = json_"""OEordItemRowID"":"""_ds.Data("OEordItemRowID")_"""," 
	s json = json_"""OEordItemDesc"":"""_ds.Data("OEordItemDesc")_"""," 
	s json = json_"""LabEpisodeNo"":"""_ds.Data("LabEpisodeNo")_""","
	s json = json_"""SpecimenDesc"":"""_ds.Data("SpecimenDesc")_""","
	s json = json_"""CollectionDate"":"""_ds.Data("CollectionDate")_""","
	s json = json_"""CollectionTime"":"""_ds.Data("CollectionTime")_""","
	s json = json_"""ReceiveDate"":"""_ds.Data("ReceiveDate")_""","
	s json = json_"""ReceiveTime"":"""_ds.Data("ReceiveTime")_""","
	s json = json_"""AuthorisationDate"":"""_ds.Data("AuthorisationDate")_""","
	s json = json_"""AuthorisationTime"":"""_ds.Data("AuthorisationTime")_""","
	s json = json_"""ExistReport"":"""_ds.Data("ExistReport")_""""
	s json = json_"}"
	s json =json_","
	q
}

/// Desc:       取检验子项
/// Creator:    Candy
/// Createdate: 2014-4-8
/// Input:     	医嘱OeordID
/// OutPut:     ItemDesc:描述,Synonym:英文缩写,ItemResult:结果,ItemUnit:单位,AbnorFlag:异常标记,ItemRanges:范围值
/// debug:      d ##Class(web.DHCCM.EMRservice.Ajax.lisData).GetSubLis("53||26")
ClassMethod GetSubLis(InterFace As %String, EpisodeID As %String, OeordID As %String, LabEpisodeNo As %String) As %String
{
	s json = ""
	s count = 0
	q:(OeordID = "") "{""total"":0,""rows"":["_json_"]}"
	if (InterFace = "数据平台")
	{
		s ds = ##Class(%Library.ResultSet).%New("web.DHCCM.EMRservice.BL.BLLisData:GetLisDataDetial")
		d ds.Execute(EpisodeID,"","",OeordID)	
	}
	else
	{
		s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectReportByOeordID")
		d ds.Execute(OeordID) 		
	}	
	
	While (ds.Next())
	{
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""OeordID"":"""_OeordID_""","
		s json = json_"""LabEpisodeNo"":"""_LabEpisodeNo_""","
		s json = json_"""EpisodeID"":"""_EpisodeID_""","
		s json = json_"""ItemDesc"":"""_ds.Data("ItemDesc")_""","
		s json = json_"""Synonym"":"""_ds.Data("Synonym")_"""," 
		s json = json_"""ItemResult"":"""_ds.Data("ItemResult")_"""," 
		s json = json_"""ItemUnit"":"""_ds.Data("ItemUnit")_"""," 
		s json = json_"""AbnorFlag"":"""_ds.Data("AbnorFlag")_"""," 
		s json = json_"""ItemRanges"":"""_ds.Data("ItemRanges")_"""" 
		s json = json_"}"
		s count = count + 1
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// Desc:       取多条检验子项 
/// debug:      w ##Class(web.DHCCM.EMRservice.Ajax.lisData).GetMultiSubLis("11323||174^11323||174")
ClassMethod GetMultiSubLis(InterFace As %String, EpisodeIDs As %String, OeordIDs As %String, LabEpisodeNos As %String) As %String
{
	s json = ""
	s count = 0
	q:(OeordIDs = "") "{""total"":0,""rows"":["_json_"]}"
	
	s idCount=$l(OeordIDs, "^")
	f i=1:1:idCount 
	{
		s OeordID = $p(OeordIDs, "^", i)
		s EpisodeID =  $p(EpisodeIDs, "^", i)
		s LabEpisodeNo =  $p(LabEpisodeNos, "^", i)
		if (InterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCCM.EMRservice.BL.BLLisData:GetLisDataDetial")
			d ds.Execute(EpisodeID,"","",OeordID)		
		}
		else
		{
			s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectReportByOeordID")
			d ds.Execute(OeordID) 	
		}
		While (ds.Next())
		{
			s:(count '=0) json =json_","
			s json = json_"{"
			s json = json_"""OeordID"":"""_OeordID_""","
			s json = json_"""LabEpisodeNo"":"""_LabEpisodeNo_""","
			s json = json_"""EpisodeID"":"""_EpisodeID_""","
			s json = json_"""ItemDesc"":"""_ds.Data("ItemDesc")_""","
			s json = json_"""Synonym"":"""_ds.Data("Synonym")_"""," 
			s json = json_"""ItemResult"":"""_ds.Data("ItemResult")_"""," 
			s json = json_"""ItemUnit"":"""_ds.Data("ItemUnit")_"""," 
			s json = json_"""AbnorFlag"":"""_ds.Data("AbnorFlag")_"""," 
			s json = json_"""ItemRanges"":"""_ds.Data("ItemRanges")_"""" 
			s json = json_"}"
			s count = count + 1
		}
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
