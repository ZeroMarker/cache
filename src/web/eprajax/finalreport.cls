Class web.eprajax.finalreport Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s EpisodeID = $Get(%request.Data("episodeID",1),"-1")
	s RuleCodes = $Get(%request.Data("ruleCodes",1),"0")
	s Type = $Get(%request.Data("type",1),"")
	q:(EpisodeID = -1)||(RuleCodes = 0)||(Type = -1) $$$OK
	
	s RuleIDs = ##Class(EPRservice.Quality.BOQualityReport).GetRuleIDsByRuleCodes(RuleCodes)
	
	//type:0-getList,1-getGradeAndScore
	if (Type = "0")
	{
		w ..GetQualityList(EpisodeID,RuleIDs)
	}
	else
	{
		w ..GetQualityGradeAndScore(EpisodeID,RuleCodes)
	}
	
	q $$$OK
}

ClassMethod GetQualityList(AEpisodeID As %String, ARuleIDs As %String) As %String
{
	s ret = ""
	s ret = ret_"<table name='tablelist' id='tablelist' width='98%' border='0' cellpadding='1' cellspacing='1' class='tableStyle01'>"
	s ret = ret_"<tr>"
	s ret = ret_"<td width='80%' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>问题描述</a></font></td>"
	s ret = ret_"<td width='20%' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>扣分</a></font></td>"
	s ret = ret_"</tr>"

	Set rset = ##Class(%ResultSet).%New("EPRservice.Quality.BOQualityReport:GetEPRQualityDetail")

	Set sc = rset.Execute(AEpisodeID,ARuleIDs)
	
 	While (rset.Next()){
		s ret = ret_"<tr id='valueTr' onDblClick='dbChoTr(this)'; onMouseDown='choTr(this,0);'>"
		s ret = ret_"<td nowrap align='left' class='TDstyle01'>"_rset.Data("EntryTitle")_"</td>"
		s ret = ret_"<td nowrap align='center' class='TDstyle01'>"_rset.Data("EntryScore")_"</td>"
		s ret = ret_"</tr>"
 	}
 	Do rset.Close()

	s ret = ret_"</table>"
	q ret
}

/// Debug w ##class(web.eprajax.finalreport).GetQualityGradeAndScore("201864","A^G")
ClassMethod GetQualityGradeAndScore(AEpisodeID As %String, ARuleCodes As %String) As %String
{
	s ResultObj = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
	q ResultObj.GetLastEvaluation(AEpisodeID)
}

}
