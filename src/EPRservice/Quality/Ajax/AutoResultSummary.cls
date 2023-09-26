/// ************************************************************
/// * Class Name:	EPRservice.Quality.Ajax.AutoResultSummary
/// * Description:	自动任务结果查询（时效在院、出院，内涵）
/// * Create Date:	2022-05-24
/// * Version:		
/// ************************************************************/
Class EPRservice.Quality.Ajax.AutoResultSummary Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s CTLocID = $g(%request.Data("CTLocID",1),"")
	s StartDate = $Get(%request.Data("StartDate",1),"")
	s EndDate = $Get(%request.Data("EndDate",1),"")
	s Type = $Get(%request.Data("Type",1),"")
	
	w ..GetAdmResultListJSON(CTLocID,StartDate,EndDate,Type)
	Quit $$$OK
}

/// Desc:			返回某科室缺陷数量;
/// Creator:		qy
/// Create Date:	20220525
/// Input:			ALocID	科室id
/// Output:			数量;
/// Debug:			##class(EPRservice.Quality.Ajax.AutoResultSummary).GetLocEntryNumByLocID(95)
ClassMethod GetLocEntryNumByLocID(ALocID As %String)
{
	s ret=""
	q:(ALocID="") ret
	s json=..GetAdmResultListJSON(ALocID,"","","A")
	s obj={}.%FromJSON(json)
	s ret=obj.total
	q ret
}

/// Desc:			明细表json
/// Creator:		qy
/// Create Date:	20220525
/// Input:			ALocID		科室id
/// 				AStartDate	开始日期
/// 				AEndDate	结束日期
/// 				APAAdmStatus患者状态 A D
/// Output:			json;
/// Debug:			##class(EPRservice.Quality.Ajax.AutoResultSummary).GetAdmResultListJSON("95","","","A")
ClassMethod GetAdmResultListJSON(ALocID As %String, AStartDate As %String, AEndDate As %String, APAAdmStatus As %String) As %String
{
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.Ajax.AutoResultSummary:GetResultList")
 	s sc = result.Execute(APAAdmStatus,AStartDate,AEndDate,ALocID)

 	s json = ""
 	s count = 0
	While (result.Next())
 	{
		s:(count '=0) json =json_","
		s json = json_"{"
	 	s json = json_"""AEpisodeID"":"""_$g(result.Data("AEpisodeID"))_""","
	 	s json = json_"""Name"":"""_$g(result.Data("Name"))_""","
	 	s json = json_"""LocDesc"":"""_$g(result.Data("LocDesc"))_""","
	 	s json = json_"""DoctorDesc"":"""_$g(result.Data("DoctorDesc"))_""","
	 	s json = json_"""RegNo"":"""_$g(result.Data("RegNo"))_""","
	 	s json = json_"""MRNo"":"""_$g(result.Data("MRNo"))_""","
	 	s json = json_"""EntryID"":"""_$g(result.Data("EntryID"))_""","
	 	s json = json_"""EntryTitle"":"""_$g(result.Data("EntryTitle"))_""","
	 	s json = json_"""Score"":"""_$g(result.Data("Score"))_""","
	 	s json = json_"""AdmitDate"":"""_$g(result.Data("AdmitDate"))_""","
	 	s json = json_"""DischDate"":"""_$g(result.Data("DischDate"))_""""
	 	s json = json_"}"
	 	s json = $tr(json,$c(10),"")
		s json = $tr(json,$c(13),"")
		s count = count + 1		
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	q json
}

/// Desc:			结果明细查询
/// Creator:		qy
/// Create Date:	20220525
/// Input:			ALocID		科室id
/// 				AStartDate	开始日期
/// 				AEndDate	结束日期
/// 				APAAdmStatus患者状态 A D
/// Output:	
/// Debug: 			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.Ajax.AdmResultList","GetResultList","A","2020-01-01","2020-06-23","")
Query GetResultList(APAAdmStatus As %String, AStartDate As %String, AEndDate As %String, ALocID As %String) As %Query(ROWSPEC = "AEpisodeID,Name,LocDesc,RegNo,MRNo,EntryID,EntryTitle,Score,AdmitDate,DischDate,DoctorDesc") [ SqlProc ]
{
}

ClassMethod GetResultListExecute(ByRef qHandle As %Binary, APAAdmStatus As %String, AStartDate As %String, AEndDate As %String, ALocID As %String) As %Status
{
 
    s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	if ((AStartDate '= "")&&(AEndDate '= "")&&(APAAdmStatus="A"))
	{
		//在院患者按日期查询
		s StDate = $zdh(AStartDate,3),EndDate=$zdh(AEndDate,3)
		for i = StDate:1:EndDate {
			s PAADMRowID = ""
			for {	
				s PAADMRowID = $o(^PAADMi("PAADM_AdmDate",i,PAADMRowID))
				q:(PAADMRowID = "")
				s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
				continue:AdmType'="I"
				s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
				continue:(xse'="")
				s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
				continue:(AdmStatus '= APAAdmStatus)
				s flag=..GetResultList(PAADMRowID,ALocID,APAAdmStatus,6,repid)
			}
		}			
	}
	elseif ((AStartDate '= "")&&(AEndDate '= "")&&(APAAdmStatus="D"))
	{
		//出院患者按日期查询
		s StDate = $zdh(AStartDate,3),EndDate=$zdh(AEndDate,3)
		for i = StDate:1:EndDate {
			s PAADMRowID = ""
			for {
				s PAADMRowID = $o(^PAADMi("DischDate",i,PAADMRowID))
				q:(PAADMRowID = "")
				s AdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
				continue:AdmType'="I"
				s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
				continue:(xse'="")
				s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
				continue:(AdmStatus '= APAAdmStatus)
				s flag=..GetResultList(PAADMRowID,ALocID,APAAdmStatus,7,repid)
			}
		}			
	}
	elseif ((AStartDate = "")&&(AEndDate = "")&&(APAAdmStatus="A"))
	{
		s PAADMRowID = ""
		for {
			
			s PAADMRowID = $o(^PAADMi("AdmTypeCurr","I",PAADMRowID))
			q:(PAADMRowID = "")
			s xse = $P($g(^PAADM(PAADMRowID)),"^",75)
			continue:(xse'="")
			s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
			continue:(AdmStatus '= APAAdmStatus)
			s flag=..GetResultList(PAADMRowID,ALocID,APAAdmStatus,6,repid)
		}
	}
	
	//排序
	s LocDesc = ""
	for {
		s LocDesc = $o(^CacheTemp("EMRQuality","ResultList",repid,LocDesc))
		q:(LocDesc = "")
		s EpisodeID=""
		for
		{
			s EpisodeID = $o(^CacheTemp("EMRQuality","ResultList",repid,LocDesc,EpisodeID))
			q:(EpisodeID = "")	
			s num = ""
			for {
				s num = $o(^CacheTemp("EMRQuality","ResultList",repid,LocDesc,EpisodeID,num))
				q:(num = "")
				s Data = $g(^CacheTemp("EMRQuality","ResultList",repid,LocDesc,EpisodeID,num))
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1	
				}
		}
	}
    k ^CacheTemp("EMRQuality","ResultList",repid)

	Quit $$$OK
}

ClassMethod GetResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResultListExecute ]
{
	s repid = $list(qHandle,2)
  	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResultListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" { // if there are no more rows, finish fetching
  Set AtEnd=1
  Set Row=""
  }
  Else      { // fetch row
  Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:			明细表json
/// Creator:		qy
/// Create Date:	20220525
/// Input:			AEpisodeID	就诊号
/// 				ALocID		科室id
/// 				Repair		是否修复 R U
/// 				APAAdmStatus患者状态 A D
/// 				ARuleID		质控标准id
/// 				repid		进程号
/// Output:	
/// Debug:
ClassMethod GetResultList(AEpisodeID As %String, ALocID As %String, APAAdmStatus As %String, ARuleID As %String, repid As %String)
{
	s ret = -1
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	s AdmLocID = $p(objPaAdm,"^",4)
	q:(AdmLocID = "") ret
	q:(ALocID '= "")&&(AdmLocID '= ALocID) ret

	s AdmDocID = $p(objPaAdm,"^",9)
	s:(AdmDocID = "") AdmDocID = "-1"
	//q:(ADoctorID '= "")&&(AdmDocID '= ADoctorID) ret
				
	s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleEpisodeID"," "_ARuleID," "_AEpisodeID,""))
	q:(ResultID = "") ret
	
	s objResult = $g(^DHCEPRQ.QualityResultD(+ResultID))
	q:(objResult = "") ret

	// 以下取患者基本信息和就诊信息
	s PatientID = $p(objPaAdm,"^",1)
	s Papmi=PatientID
	s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
	s MRNo = ##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"I","",.ErrMsg)
	s AdmitDate = $zd($p(objPaAdm,"^",6),3)
	s DischDate = $p(objPaAdm,"^",17)
	s:(DischDate '= "") DischDate = $zd(DischDate,3)
	s LocDesc = $p($g(^CTLOC(+AdmLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s LocDesc=##class(EMRservice.HISInterface.Translation).GetTranByDesc("User.CTLoc","CTLOCDesc",LocDesc)
	s DoctorDesc = $s(AdmDocID '= -1:$p($g(^CTPCP((+AdmDocID),1)),"^",2),1:"未指定")
	s DoctorDesc=##class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",DoctorDesc)
	s ScoreGrade = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(AEpisodeID)
    s Score = $p(ScoreGrade,"^",1)
	s Grade = $p(ScoreGrade,"^",2)
	
	//时效缺陷明细
	s num=0
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BOQualityReport:GetEPRQualityDetail")
	s sc = result.Execute(AEpisodeID,ARuleID)
	While (result.Next())
	{
	    s EntryID=result.Data("EntryID")
	    s EntryTitle=result.Data("EntryTitle")
	    s RepairFlag=""
	    s num=num+1
	    s ^CacheTemp("EMRQuality","ResultList",repid,LocDesc,AEpisodeID,num) = $lb(AEpisodeID,Name,LocDesc,RegNo,MRNo,EntryID,EntryTitle,Score,AdmitDate,DischDate,DoctorDesc)	
	}
	
	//有内涵质控也显示
	if (##class(%Dictionary.CompiledQuery).%ExistsId("EPRservice.Quality.DataAccess.BOQualityAiLog||GetAiResultDetail"))
	{
		s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityAiLog:GetAiResultDetail")
		s sc = result.Execute(AEpisodeID,"E",APAAdmStatus)
		While (result.Next())
		{
		s EntryID=result.Data("EntryDR")
	    s EntryTitle=result.Data("Title")
	    s num=num+1
	    s ^CacheTemp("EMRQuality","ResultList",repid,LocDesc,AEpisodeID,num) = $lb(AEpisodeID,Name,LocDesc,RegNo,MRNo,EntryID,EntryTitle,Score,AdmitDate,DischDate,DoctorDesc)	
		}
	}
	s ret = 1
	q ret
}

}
