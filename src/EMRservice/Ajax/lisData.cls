Class EMRservice.Ajax.lisData Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

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
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	s labEpisodeNo = $Get(%request.Data("LabEpisodeNo",1),"")
	s userID = $g(%session.Data("LOGON.USERID"))
	s OEordItemRowID = $Get(%request.Data("OEordItemRowID",1),"")
	s OEordItemDesc = $Get(%request.Data("OEordItemDesc",1),"")
	if (action = "GetLisData")
	{
		s patientID = $Get(%request.Data("PatientID",1),"")
		s dateGap = $Get(%request.Data("DateGap",1),"")
		s length = $l(episodeId,",")
		s admType = ""
		s:(episodeId '= "")&&(length = 1) admType = $p($g(^PAADM(episodeId)),"^",2)
		s searchInput = $Get(%request.Data("SearchInput",1),"")
 		w ..GetLisData(interface,episodeId,startDateTime,endDateTime,authStDateTime,authEndDateTime,authorizedFlag,idxStart,idxLast,patientID,dateGap,admType,searchInput)
	}
	elseif (action = "GetSubLis")
	{
		w ..GetSubLis(interface,episodeId,Id,labEpisodeNo)
	}
	elseif (action = "GetMultiSubLis")
	{
		w ..GetMultiSubLis(interface,episodeId,Id,labEpisodeNo)
	}
	elseif (action = "InputReferenceDataLog")
	{
		w ##Class(EMRservice.BL.BLLisdataReference).AddLisdataReferenceData(episodeId,userID,OEordItemRowID,OEordItemDesc)
	}	
	Quit $$$OK
}

/// Desc:       取检验项
/// Creator:    Candy
/// Createdate: 2014-4-8
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10
///             EpisodeIDs:就诊号
///             StDate:开始时间
///             EndDate:结束时间
///             AuthStDate:审核查询开始时间
///             AuthEndDate:审核查询结束时间
///             AuthorizedFlag:审核标识,0为本次就诊未审核;1为本次就诊审核;2为该患者最新两次就诊所有,目前仅HISUI门诊页面提供
///             StartPage:返回分页开始页号
///             EndPage:返回分页结束页号
///             PatientID:病人PatientID
///             DateGap:就诊日期间隔,例如90天,目前仅门诊页面提供
///             AdmType:本次就诊类型,用于标识是否为门诊
/// Output:     EpisodeDate:就诊日期,DeptDesc:就诊科室,OEordItemRowID:医嘱ID,OEordItemDesc:医嘱名称,LabEpisodeNo:标本号,
///             SpecimenDesc:标本类型,CollectionDate:标本采集日期,CollectionTime:标本采集时间,ReceiveDate:标本接收日期,
///             ReceiveTime:标本接收时间,AuthorisationDate:标本审核日期,AuthorisationTime:标本审核时间,
///             ExistReport:是否有报告(Y:存在，N:不存在)
///             w ##Class(EMRservice.Ajax.lisData).GetLisData("HIS","34","","","","","",1,10)
ClassMethod GetLisData(AInterFace As %String, EpisodeIDs As %String, StDate As %String, EndDate As %String, AuthStDate As %String = "", AuthEndDate As %String = "", AuthorizedFlag As %String = "", StartPage As %Integer, EndPage As %Integer, PatientID As %String = "", DateGap As %String = "", AdmType As %String = "", ASearchInput As %String = "") As %String
{
	s json = ""
	s result = ""
	s TotalCount = 0
	s count = 0
	q:(EpisodeIDs = "") "{""total"":0,""rows"":["_json_"]}"
	s:(AuthorizedFlag =2) EpisodeIDs = ##Class(EMRservice.Ajax.hisData).GetEpisodeIdsByPatientId(PatientID,AuthorizedFlag)
	s:(AdmType = "O")&&(DateGap '= "") EpisodeIDs = ##Class(EMRservice.Ajax.hisData).GetEpisodeIdsByPatientId(PatientID,"",DateGap)
	s key = $i(^CacheTemp)
	k ^TempEMRLisData(key)
	///审核时间查询条件的格式转换
	s:(AuthStDate'="") AuthStDate = $zdh(AuthStDate,3)
	s:(AuthEndDate'="") AuthEndDate= $zdh(AuthEndDate,3)
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
		s deptId = $p($g(^PAADM(episodeId)),"^",4)
		s deptDesc = $Case(deptId,"":"",:$p(^CTLOC(deptId),"^",2))
		s:($f(deptDesc,"-") '= 0) deptDesc = $p(deptDesc,"-",2)
		
		if (AInterFace = "HIS")
		{
			s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectLISItemListByDate")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		elseif (AInterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLLisData:GetLisDataList")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)		
		}
		elseif (AInterFace = "HSBToHis")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISItemListByDate")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		
		///若审核时间查询条件为当天
		if (AuthStDate'="")&&(AuthStDate=AuthEndDate)
		{
		While (ds.Next())
			{
				continue:ds.Data("AuthorisationDate")=""
				continue:($zdh(ds.Data("AuthorisationDate"),3)'=AuthStDate)
				if (ASearchInput '="")
				{
					continue:(ds.Data("OEordItemDesc")'[ ASearchInput)
				}				
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		///若审核时间查询条件为三天或一周
		elseif(AuthStDate'="")&&(AuthStDate'=AuthEndDate)
		{
			While (ds.Next())
			{
				continue:ds.Data("AuthorisationDate")=""
				continue:'(($zdh(ds.Data("AuthorisationDate"),3)>=AuthStDate)&&($zdh(ds.Data("AuthorisationDate"),3)<=AuthEndDate))
				if (ASearchInput '="")
				{
					continue:(ds.Data("OEordItemDesc")'[ ASearchInput)
				}				
				s TotalCount = TotalCount + 1 
				d setJson
			 }
		}
		///若审核时间查询条件为本次就诊
		elseif(AuthorizedFlag = 1)
		{
			While (ds.Next())
			{
				continue:'(ds.Data("AuthorisationDate")'="")
				if (ASearchInput '="")
				{
					continue:(ds.Data("OEordItemDesc")'[ ASearchInput)
				}				
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		///未审核
		elseif(AuthorizedFlag = 0)
		{
			While (ds.Next())
			{
				continue:'(ds.Data("AuthorisationDate")="")
				if (ASearchInput '="")
				{
					continue:(ds.Data("OEordItemDesc")'[ ASearchInput)
				}				
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}else
		{
			while (ds.Next())
			{
				if (ASearchInput '="")
				{
					continue:(ds.Data("OEordItemDesc")'[ ASearchInput)
				}			
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
				if ((StartPage <= i)&(i <= EndPage))
				{
					s:(j'=0) result = result_","
					s result = result_^TempEMRLisData(key,LisAuthDate,LisAuthTime,order)
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
	k ^TempEMRLisData(key)
	s result = "{""total"":"_TotalCount_",""rows"":["_result_"]}"
	s result = $ZSTRIP(result,"*C")
	q result
	q
setJson
	s isReferenceOEord = ##Class(EMRservice.BL.BLLisdataReference).GetIsReferenceOEord(episodeId,ds.Data("OEordItemRowID"))
	s json = json_"{"
	s json = json_"""EpisodeDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",episodeDate)_""","
	s json = json_"""EpisodeID"":"""_episodeId_""","
	s json = json_"""DeptDesc"":"""_deptDesc_""","
	s json = json_"""OEordItemRowID"":"""_ds.Data("OEordItemRowID")_"""," 
	s json = json_"""OEordItemDesc"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("OEordItemDesc"))_"""," 
	s json = json_"""LabEpisodeNo"":"""_ds.Data("LabEpisodeNo")_""","
	s json = json_"""SpecimenDesc"":"""_ds.Data("SpecimenDesc")_""","
	s json = json_"""AbnormalFlag"":"""_$g(ds.Data("AbnormalFlag"))_""","
	s json = json_"""IsReferenceOEord"":"""_isReferenceOEord_""","
	s json = json_"""AbnormalFlag"":"""_$g(ds.Data("AbnormalFlag"))_""","
	s json = json_"""CollectionDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("CollectionDate"))_""","
	s json = json_"""CollectionTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("CollectionTime"))_""","
	s json = json_"""ReceiveDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("ReceiveDate"))_""","
	s json = json_"""ReceiveTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("ReceiveTime"))_""","
	s json = json_"""AuthorisationDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("AuthorisationDate"))_""","
	s json = json_"""AuthorisationTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("AuthorisationTime"))_""","
	s:($g(ds.Data("ReportURL"))) json = json_"""ReportURL"":""<a href='"_ds.Data("ReportURL")_"' target='_balnk' style='scrollbars=0,resizable=0;width=300;'>影像报告</a>"","
	s json = json_"""ExistReport"":"""_ds.Data("ExistReport")_""","
	s LISRRTestConclusion = $g(ds.Data("LISRRTestConclusion"))
	s LISRRReportMark = $g(ds.Data("LISRRReportMark"))
	s json = json_"""LISRRTestConclusion"":"""_LISRRTestConclusion_""","
	s json = json_"""LISRRReportMark"":"""_LISRRReportMark_""""
	s json = json_"}"
	if (##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ds.Data("AuthorisationDate")) '= "")
	{
		s AuthDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ds.Data("AuthorisationDate"))
	}
	else
	{
		s AuthDate = "00000"
	}
	if (##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Time",ds.Data("AuthorisationTime")) '= "")
	{
		s AuthTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Time",ds.Data("AuthorisationTime"))
	}
	else
	{
		s AuthTime = "00000"
	}
	s ^TempEMRLisData(key,AuthDate,AuthTime,count) = json
	s json = ""
	s count = count + 1
	q
}

/// Desc:       取检验子项
/// Creator:    Candy
/// Createdate: 2014-4-8
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10
///            	医嘱OeordID
/// OutPut:     ItemDesc:描述,Synonym:英文缩写,ItemResult:结果,ItemUnit:单位,AbnorFlag:异常标记,ItemRanges:范围值
/// debug:      d ##Class(EMRservice.Ajax.lisData).GetSubLis("HIS",174,"53||26")
ClassMethod GetSubLis(AInterFace As %String, EpisodeID As %String, OeordID As %String, LabEpisodeNo As %String) As %String
{
	s json = ""
	s result = ""
	s count = 0
	q:(OeordID = "") "{""total"":0,""rows"":["_json_"]}"
	s key = $i(^CacheTemp)
	k ^TempEMRLisData(key)
	if (AInterFace = "HIS")
	{
		s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectReportByOeordID")
		d ds.Execute(OeordID)
	}
	elseif (AInterFace = "数据平台")
	{
		s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLLisData:GetLisDataDetial")
		d ds.Execute(EpisodeID,"","",OeordID)	
	}
	elseif (AInterFace = "HSBToHis")
	{
		s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISReportByOeordID")
		d ds.Execute(OeordID)
	}
	//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
	
	While (ds.Next())
	{
		s itemDesc = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ItemDesc"))
		s itemResult = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ItemResult"))
		s abnorFlag=""
		if ((ds.Data("AbnorFlag")="高")||(ds.Data("AbnorFlag")="H")||(ds.Data("AbnorFlag")="↑")||(ds.Data("AbnorFlag")="↑↑"))
		{
			s abnorFlag="↑"
		}
		elseif ((ds.Data("AbnorFlag")="低")||(ds.Data("AbnorFlag")="L")||(ds.Data("AbnorFlag")="↓")||(ds.Data("AbnorFlag")="↓↓"))
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
		if (AInterFace = "数据平台")
		{
			s detailData = $g(ds.Data("DetailData"),"[]")
		}
		else
		{
			if (($g(ds.Data("ResultDR")) '= ""))
			{
				s detailData = ##Class(EMRservice.Ajax.lisData).GetQryAntResult(ds.Data("ResultDR"))
			}
		}
		
		s json = json_"{"
		s json = json_"""OeordID"":"""_OeordID_""","
		s json = json_"""LabEpisodeNo"":"""_LabEpisodeNo_""","
		s json = json_"""EpisodeID"":"""_EpisodeID_""","
		s json = json_"""ItemDesc"":"""_itemDesc_""","
		s json = json_"""Synonym"":"""_$case(ds.Data("Synonym"),"":itemDesc,:ds.Data("Synonym"))_""","  
		s json = json_"""ItemResult"":"""_itemResult_"""," 
		s json = json_"""ItemUnit"":"""_itemUnit_"""," 
		s json = json_"""AbnorFlag"":"""_abnorFlag_"""," 
		s json = json_"""ItemRanges"":"""_ds.Data("ItemRanges")_"""," 
		s json = json_"""ReportDR"":"""_$g(ds.Data("ResultDR"))_""","  
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
			s:(j'=0) result = result_","
			s result = result_^TempEMRLisData(key,LisSequence,order)
			s j = j + 1
		}
	}
	k ^TempEMRLisData(key)
	
	
	s result = "{""total"":"_count_",""rows"":["_result_"]}"
	s result = $ZSTRIP(result,"*C")
	q result
}

/// Desc:       取多条检验子项
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10 
/// debug:      w ##Class(EMRservice.Ajax.lisData).GetMultiSubLis("HIS",174,"11323||174^11323||174")
ClassMethod GetMultiSubLis(AInterFace As %String, EpisodeIDs As %String, OeordIDs As %String, LabEpisodeNos As %String) As %String
{
	s json = ""
	s result = ""
	s count = 0
	q:(OeordIDs = "") "{""total"":0,""rows"":["_json_"]}"
	
	s idCount=$l(OeordIDs, "^")
	f i=1:1:idCount 
	{
		s OeordID = $p(OeordIDs, "^", i)
		s EpisodeID =  $p(EpisodeIDs, "^", i)
		s LabEpisodeNo =  $p(LabEpisodeNos, "^", i)
		s key = $i(^CacheTemp)
		k ^TempEMRLisData(key)
		if (AInterFace = "HIS")
		{
			s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectReportByOeordID")
			d ds.Execute(OeordID)
		}
		elseif (AInterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLLisData:GetLisDataDetial")
			d ds.Execute(EpisodeID,"","",OeordID)	
		}
		elseif (AInterFace = "HSBToHis")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISReportByOeordID")
			d ds.Execute(OeordID)
		}
		//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		While (ds.Next())
		{
			s itemDesc = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ItemDesc"))
			s itemResult = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data("ItemResult"))
			s abnorFlag = ""
			if ((ds.Data("AbnorFlag")="高")||(ds.Data("AbnorFlag")="H"))
			{
				s abnorFlag="↑"
			}
			elseif ((ds.Data("AbnorFlag")="底")||(ds.Data("AbnorFlag")="L"))
			{
				s abnorFlag="↓"
			}
			s detailData = "[]"
			if (AInterFace = "数据平台")
			{
				s detailData = $g(ds.Data("DetailData"),"[]")
			}
			else
			{
				if (($g(ds.Data("ResultDR")) '= ""))
				{
					s detailData = ##Class(EMRservice.Ajax.lisData).GetQryAntResult(ds.Data("ResultDR"))
				}
			}
			s json = json_"{"
			s json = json_"""OeordID"":"""_OeordID_""","
			s json = json_"""LabEpisodeNo"":"""_LabEpisodeNo_""","
			s json = json_"""EpisodeID"":"""_EpisodeID_""","
			s json = json_"""ItemDesc"":"""_itemDesc_""","
			s json = json_"""Synonym"":"""_ds.Data("Synonym")_"""," 
			s json = json_"""ItemResult"":"""_itemResult_"""," 
			s json = json_"""ItemUnit"":"""_ds.Data("ItemUnit")_"""," 
			s json = json_"""AbnorFlag"":"""_abnorFlag_"""," 
			s json = json_"""ItemRanges"":"""_ds.Data("ItemRanges")_"""," 
			s json = json_"""ReportDR"":"""_$g(ds.Data("ResultDR"))_"""," 
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
				s:((j'=0)||(i'=1)) result = result_","
				s result = result_^TempEMRLisData(key,LisSequence,order)
				s j = j + 1
			}
		}
		k ^TempEMRLisData(key)
	}
	s result = "{""total"":"_count_",""rows"":["_result_"]}"
	s result = $ZSTRIP(result,"*C")
	q result
}

/// Desc:       取微生物药敏结果
/// Creator:    Donglulu
/// CreateDate: 2018-9-29
/// Input:      ReportDR
/// Output:     json
/// ##Class(EMRservice.Ajax.lisData).GetQryAntResult("468")
ClassMethod GetQryAntResult(AReportDR As %String)
{
	s json = ""
	s count = 0
	q:(AReportDR = "") "{""total"":"_count_",""rows"":["_json_"]}"
	s ds = ##class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryReportResultSen")
	d ds.Execute(AReportDR)
	s columCount = ds.GetColumnCount()
	while ds.%Next()
	{  
		s sensitivityName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($g(ds.Data("SensitivityName"))) 
		s antibioticsName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($g(ds.Data("AntibioticsName"))) 
		s sName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($g(ds.Data("SName"))) 
		s senMethod = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($g(ds.Data("SenMethod")))
		s json = json_"{"
		s json = json_"""ReportDR"":"""_AReportDR_""","
		s json = json_"""RowID"":"""_$g(ds.Data("RowID"))_""","
		s json = json_"""AntibioticsDR"":"""_$g(ds.Data("AntibioticsDR"))_""","
		s json = json_"""SenMethod"":"""_senMethod_""","
		s json = json_"""SenValue"":"""_$g(ds.Data("SenValue"))_""","
		s json = json_"""SensitivityDR"":"""_$g(ds.Data("SensitivityDR"))_""","
		s json = json_"""IRanges"":"""_$g(ds.Data("IRanges"))_""","
		s json = json_"""SRanges"":"""_$g(ds.Data("SRanges"))_""","
		s json = json_"""RRanges"":"""_$g(ds.Data("RRanges"))_""","
		s json = json_"""Sequence"":"""_$g(ds.Data("Sequence"))_""","
		s json = json_"""AntibioticsClassDR"":"""_$g(ds.Data("AntibioticsClassDR"))_""","
		s json = json_"""SensitivityName"":"""_sensitivityName_""","
		s json = json_"""AntibioticsName"":"""_antibioticsName_""","
		s json = json_"""SName"":"""_sName_""""  
		s json = json_"}"
		s json = json_","
		s count = count + 1
	}
	s json = $e(json,1,$l(json)-1)
	s json = $ZSTRIP(json,"*C")
	q "["_json_"]"
}

}
