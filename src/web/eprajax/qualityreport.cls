Class web.eprajax.qualityreport Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s $zt = "ErrorHandler"
	s recordType = $Get(%request.Data("RecordType",1),"")
	if (recordType = "0")
	{
		w ..GetQualityReport()
	}
	else
	{
		w ..GetQualityFinalReport()
	}
	Quit $$$OK
ErrorHandler
 	Quit $$$OK
}

/// Desc:       提示列表信息
/// Creator:    Candy
/// CreateDate: 2014-9-29
/// Input:      Null
/// OutPut:     提示列表
/// Debug:      w ##Class(web.eprajax.qualityreport).GetQualityReport()
ClassMethod GetQualityReport() As %String
{
	s result = ""
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s ctLocID = $Get(%request.Data("CTLocID",1),"")
	s ssGroupID = $Get(%request.Data("SSGroupID",1),"")
	q:((episodeID = "")||(ctLocID = "")||(ssGroupID = "")) result
	
	s ruleID = $o(^DHCEPRM.QualityRuleI("IdxCode","B",""))
	q:(ruleID = "") result
	s result = "<table id='tablelist' width='100%' cellpadding='1' cellspacing='1'  class='tableStyle01'>"
	s rset = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetPromptList")
	s sc = rset.Execute(episodeID, ruleID_"_"_ssGroupID_"_"_ctLocID)
	While (rset.Next()){
		s result = result_"<tr style='background-color:"_rset.Data("PhaseColor")_"'>"
		s result = result_"<td nowrap align='left' class='TDstyle01'>"_rset.Data("EntryDesc")_"</td>"
		s result = result_"<td nowrap align='center' class='TDstyle01'>"_rset.Data("DocName")_"</td>"
		s result = result_"<td nowrap align='center' class='TDstyle01'>"_rset.Data("PhaseName")_"</td>"
		s result = result_"</tr>"
 	}
 	d rset.Close()
	s result = result_"</table>"
	q result
}

/// Desc:       终末质控
/// Creator:    Candy
/// CreateDate: 2014-9-29
/// Debug:      d ##Class(web.eprajax.qualityreport).GetQualityFinalReport()
ClassMethod GetQualityFinalReport() As %String
{
	s result = ""
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	q:(episodeID = "") result
    s ruleCodes = "A^G"
    s result = "<div>"
    s result = result_..GetQualityGradeAndScore(episodeID,ruleCodes)
    s result = result_"</div>"
    s result = result_..GetQualityList(episodeID,ruleCodes)
    q result
}

/// Desc:       最终评价列表
/// Creator:    Candy
/// CreateDate: 2014-9-29
/// Input:      AEpisodeID 就诊号
/// 			   ARuleCodes 就诊代码
/// OutPut:     质控结果
/// Debug:      w ##class(web.eprajax.finalreport).GetQualityList("201864","A^G")
ClassMethod GetQualityList(AEpisodeID As %String, ARuleCodes As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ARuleCodes = "")) result
	s count = $l(ARuleCodes,"^")
	q:(count = 0) result
	s ruleIds = ""
	for I=1:1:count
	{
		s ruleCode = $p(ARuleCodes,"^",I)
		s:(I '= 1) ruleIds = ruleIds_"^" 
		s ruleIds =ruleIds_$o(^DHCEPRM.QualityRuleI("IdxCode",ruleCode,""))
	}
	
	s result = result_"<table id='tablelist'  cellpadding='1' cellspacing='1' class='tableStyle01'>"
	s rset = ##Class(%ResultSet).%New("EPRservice.Quality.BOQualityReport:GetEPRQualityDetail")
	s sc = rset.Execute(AEpisodeID,ruleIds)
 	While (rset.Next()){
		s result = result_"<tr>"
		s result = result_"<td nowrap align='left' class='TDstyle01'>"_rset.Data("EntryTitle")_"</td>"
		s result = result_"<td nowrap align='center' class='TDstyle01'>"_rset.Data("EntryScore")_"</td>"
		s result = result_"</tr>"
 	}
 	d rset.Close()
	s result = result_"</table>"
	q result
}

/// Desc:       最终评价结果
/// Creator:    Candy
/// CreateDate: 2014-9-29
/// Input:      AEpisodeID 就诊号
/// 			   ARuleCodes 就诊代码
/// OutPut:     质控结果
/// Debug:      w ##class(web.eprajax.finalreport).GetQualityGradeAndScore("201864","A^G")
ClassMethod GetQualityGradeAndScore(AEpisodeID As %String, ARuleCodes As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ARuleCodes = "")) result
	s ResultObj = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
	s result = ResultObj.GetLastEvaluation(AEpisodeID)
	q result
}

}
